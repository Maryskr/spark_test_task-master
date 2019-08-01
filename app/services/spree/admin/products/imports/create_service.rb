require 'csv'

module Spree
  module Admin
    module Products
      module Imports
        class CreateService < Service
          def initialize(file)
            self.file = file
            self.products = []
            self.errors =[]
          end

          def call
            options = { skip_blanks: true, headers: true, col_sep: ';' }
            CSV.foreach(file.path, options) do |row|
              next unless row['name'].present? || row['price'].present?
              product = build_from_row(row)
              product.price = row['price']
              if product.valid?
                product.save
                stock_item = build_stock_item(product, row)
                products << product.id
              else
                errors << { index: $., message: product.errors&.full_messages&.join(', ') }
              end
            end
            Result.new(errors.any?, products, errors)
          end

          private

          def build_from_row(row)
            ::Spree::Product.new(
              name: row['name'],
              description: row['description'],
              slug: row['slug'],
              available_on: row['availability_date']&.to_date,
              tax_category_id: ::Spree::TaxCategory.find_or_create_by(name: row['category'])&.id,
              shipping_category_id: ::Spree::ShippingCategory.first.id
            )
          end

          def build_stock_item(product, row)
            product.stock_items.create(
              variant_id: product.master.id,
              count_on_hand: row['stock_total'].to_i,
              stock_location_id: ::Spree::StockLocation.active.first.id
            )
          end

          attr_accessor :file, :products, :errors
        end
      end
    end
  end
end
