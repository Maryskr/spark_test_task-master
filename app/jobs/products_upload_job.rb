class ProductsUploadJob < ApplicationJob
  queue_as :default

  OPTIONS = { encoding: Encoding::UTF_8 }.freeze
  LOCATION = '/tmp/'

  def perform(attachment_id)
    attachment = ::Spree::Products::Imports::Attachment.find(attachment_id)
    return unless attachment
    file = File.open(attachment.file.url)
    ::Spree::Admin::Products::Imports::CreateService.call(file)
    # TODO it would be nice to notify user about upload result. for example,
    # send mail with CSV file wich contain list of successfully loaded products
    # and list of errors!
  end
end
