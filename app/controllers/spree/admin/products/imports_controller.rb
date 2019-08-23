module Spree
  module Admin
    module Products
      class ImportsController < Spree::Admin::BaseController
        include ::Spree::Admin::NavigationHelper

        def new; end

        def create
          obj = S3_BUCKET.object(filename)
          obj.upload_file(path)

          if obj.public_url
            ::ProductsUploadJob.perform_later(obj.public_url, filename)
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

        def filename
          import_params[:file]&.original_filename
        end

        def path
          import_params[:file].path
        end
      end
    end
  end
end