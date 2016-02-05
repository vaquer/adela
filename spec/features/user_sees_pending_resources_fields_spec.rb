require 'spec_helper'

feature User, 'sees pending documentation:' do
  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
    given_organization_with_opening_plan
  end

  scenario 'when loading the catalog view for the first time' do
    click_link 'Catálogo de Datos'

    set_rows.each do |row|
      expect(row.text).to match(/\d+ de \d+/)
    end

    resource_rows.each do |row|
      expect(row.text).to have_content(/(Falta información|Listo para publicar)/)
      expect(row.text).to have_content(/(Actualizar)|(Completar)/)
    end
  end
end
