require 'pry'

module Spree
  module Products
    module Imports
      class Attachment < ActiveRecord::Base
        self.table_name = 'attachments'

        has_attached_file :file
        validates_attachment_content_type :file, content_type: ['text/plain']
      end
    end
  end
end
