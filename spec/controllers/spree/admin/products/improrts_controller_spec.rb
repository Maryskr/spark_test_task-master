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

        products = Spree::Product.all

        expect(assigns(:errors)).to eq([])
        expect(products.count).to eq(3)

        expect(products.first.name).to match 'Ruby on Rails Bag'
        expect(products.first.description).to match 'Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.'
        expect(products.first.price.to_s).to eq('22.99')
      end
    end

    context 'with empty shipping_category and stock_location' do
      let(:file) { fixture_file_upload(Rails.root.join('sample.csv')) }
      let(:expected_errors) do
        [
          {:index=>2, :message=>"Shipping Category can't be blank"},
          {:index=>3, :message=>"Shipping Category can't be blank"},
          {:index=>4, :message=>"Shipping Category can't be blank"}
        ]
      end

      it 'responds with errors' do
        post :create, params: { file: file }

        products = Spree::Product.all

        expect(assigns(:errors)).to eq(expected_errors)
        expect(products.count).to eq(0)
      end
    end
  end
end
