require 'rails_helper'

describe 'imprort product from CSV', type: :feature do

  context 'as admin user' do
    let(:file) { fixture_file_upload(Rails.root.join('sample.csv')) }
    stub_authorization!

    it 'upload CSV file' do
      visit spree.admin_products_path
      click_link 'Import from CSV'
      expect(page).to have_content(I18n.t('spree.admin.products.imports.new.import_csv_warning').strip_html_tags)

      attach_file('file', file.path)
      click_on 'Upload'

      expect(page).to have_content(I18n.t('spree.admin.products.imports.create.success'))
    end
  end
end
