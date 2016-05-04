require 'spec_helper'

feature User, 'Uploads organization documents:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario 'uploads the designation file and the authorization file', js: true do
    within('.navbar') { click_on('Documentos') }
    attach_organization_documents

    sees_success_message I18n.t('flash.notice.organization.documents.update')
    expect(page).to have_text('designation_file.docx')
    expect(page).to have_text('memo_file.pdf')
  end

  def attach_organization_documents
    within('.edit_organization') do
      attach_file('organization_designation_files_attributes_0_file', "#{Rails.root}/spec/fixtures/files/designation_file.docx")
      attach_file('organization_memo_files_attributes_0_file', "#{Rails.root}/spec/fixtures/files/memo_file.pdf")
      click_on('Subir documentos')
    end
  end
end
