require 'rails_helper'

RSpec.describe Spree::Admin::Products::ImportsController, type: :controller do
  describe 'GET #new' do
    stub_authorization!

    it 'responds successfully with an HTTP 200 status code' do
      get :new

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    stub_authorization!

    context 'with valid shipping_category and stock_location' do
      let!(:shipping_category) { create(:shipping_category) }
      let!(:stock_location) { create(:stock_location) }
      let(:file) { fixture_file_upload(Rails.root.join('sample.csv')) }

      subject { post :create, params: { file: file } }

      it 'responds successfully with an HTTP 200 status code' do
        ActiveJob::Base.queue_adapter = :test

        post :create, params: { file: file }

        expect(flash[:error]).to eq nil
        expect(flash[:success]).not_to be_empty
      end

      it { expect {subject}.to change{::Spree::Products::Imports::Attachment.count}.by(1) }
      it { expect { subject }.to have_enqueued_job(::ProductsUploadJob) }
    end
  end
end
