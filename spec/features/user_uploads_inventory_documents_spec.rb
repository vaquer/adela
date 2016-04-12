require 'spec_helper'

feature User, 'uploads inventory documents:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'uploads the designation file and the authorization file', js: true do
    given_an_inventory_with_documents
    sees_success_message I18n.t('flash.notice.inventory.update')
  end

  scenario 'hides the documents form once the user has uploaded the documents' do
    given_an_inventory_with_documents
    expect(page).not_to have_css('.edit_inventory')
  end

  scenario 'cant submit the form without an authorization file and designation file', js: true do
    expect(page).not_to have_css('.edit_inventory')
    within('.navbar') { click_on('Inventario de Datos') }
    within('.edit_inventory') do
      click_on('Subir oficios')
      find(:css, '#inventory_designation_file-error', text: 'Completa este campo')
      find(:css, '#inventory_authorization_file-error', text: 'Completa este campo')
    end
  end

  def given_an_inventory_with_documents
    within('.navbar') { click_on('Inventario de Datos') }
    within('.edit_inventory') do
      attach_file('inventory_designation_file', "#{Rails.root}/spec/fixtures/files/oficio_designacion.docx")
      attach_file('inventory_authorization_file', "#{Rails.root}/spec/fixtures/files/authorization_file.jpg")
      click_on('Subir oficios')
    end
  end
end
