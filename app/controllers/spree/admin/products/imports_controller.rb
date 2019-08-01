module Spree
  module Admin
    module Products
      class ImportsController < Spree::Admin::BaseController
        include ::Spree::Admin::NavigationHelper

        def new; end

        def create
          result = ::Spree::Admin::Products::Imports::CreateService.call(import_params[:file])
          @errors = result.error
          if @errors.any?
            @collection = ::Spree::Product.where(id: result.value)
            render :new
          else
            flash[:success] = t('.success')
            redirect_to admin_products_path
          end
        end

        private

        def import_params
          params.permit(:file)
        end
      end
    end
  end
end