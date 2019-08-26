# frozen_string_literal: true

require 'rails_helper'

describe Spree::Admin::Products::Imports::CreateService do

  describe 'change status and substatus' do
    let(:file) { fixture_file_upload(Rails.root.join('sample.csv')) }

    context 'create products with' do
      let!(:shipping_category) { create(:shipping_category) }
      let!(:stock_location) { create(:stock_location, active: true) }

      subject { Spree::Admin::Products::Imports::CreateService.call(file) }

      it { expect { subject }.to change(Spree::Product, :count).by(3) }

      it 'create product with attributes' do
        subject
        product = Spree::Product.first

        expect(product.name).to match 'Ruby on Rails Bag'
        expect(product.description).to match 'Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.'
        expect(product.price.to_s).to eq('22.99')
      end
    end

    context 'with empty shipping_category and stock_location' do
      subject { Spree::Admin::Products::Imports::CreateService.call(file) }

      it { expect { subject }.not_to change(Spree::Product, :count) }
    end
  end
end
