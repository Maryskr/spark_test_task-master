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

      it 'responds successfully with an HTTP 200 status code' do
        post :create, params: { file: file }

        expect(flash[:error]).to eq nil
        expect(flash[:success]).not_to be_empty
      end
    end
  end
end
