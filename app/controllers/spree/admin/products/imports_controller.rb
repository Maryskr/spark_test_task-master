module Spree
  module Admin
    module Products
      class ImportsController < Spree::Admin::BaseController

        def new; end

        def create
          result = ::Spree::Admin::Products::Imports::CreateService.call(import_params[:file])
          @errors = result.error
          @collection = ::Spree::Product.where(id: result.value)
          @search = @collection.ransack(params[:q]&.reject { |k, _v| k.to_s == 'deleted_at_null' })
          render :new
        end

        private

        def import_params
          params.permit(:file)
        end
      end
    end
  end
end