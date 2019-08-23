class ProductsUploadJob < ApplicationJob
  queue_as :default

  OPTIONS = { encoding: Encoding::UTF_8 }.freeze
  LOCATION = '/tmp/'

  def perform(file_url, filename)
    obj = S3_BUCKET.object(filename)
    path = Rails.root.join('tmp', filename)
    file = File.open(path, "w+")
    obj.get(response_target: path)
    ::Spree::Admin::Products::Imports::CreateService.call(file)
    File.delete(path) if File.exist?(path)
  end
end
