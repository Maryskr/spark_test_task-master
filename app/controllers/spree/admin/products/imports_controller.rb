module Spree
  module Admin
    module Products
      class ImportsController < Spree::Admin::BaseController
        include ::Spree::Admin::NavigationHelper

        def new; end

        def create
          attachment = ::Spree::Products::Imports::Attachment.new(file: import_params[:file])
          if attachment.save
            ::ProductsUploadJob.perform_later(attachment.id)
            flash[:success] = t('.success')
          else
            flash[:error] = t('.error')
          end
          redirect_to admin_products_path
        end

        private

        def import_params
          params.permit(:file)
        end
      end
    end
  end
end