require 'spec_helper'

feature User, 'sees steps message:' do
  background do
    @user = create(:user)
    @organization = @user.organization
    given_logged_in_as(@user)
  end

  scenario 'when no inventory file has been uploaded' do
    click_link 'Catálogo de Datos'

    expect(page).to have_content 'Antes de poder publicar el Catálogo de Datos es necesario haber concluido los siguientes pasos:'
    expect(page).to have_content 'Subir el Inventario de Datos'
    expect(page).to have_content 'Generar Plan de Apertura'

    expect(step_link_href_for 'Subir el Inventario de Datos').to include inventories_path
    expect(step_link_href_for 'Generar Plan de Apertura').to include opening_plans_path
  end

  scenario 'when inventory file has been uploaded' do
    given_organization_with_inventory
    click_link 'Catálogo de Datos'

    expect(page).to have_content 'Antes de poder publicar el Catálogo de Datos es necesario haber concluido los siguientes pasos:'
    expect(page).to have_content 'Subir el Inventario de Datos'
    expect(page).to have_content 'Generar Plan de Apertura'
  end

  scenario 'unless an opening plan exists and an inventory file has been uploaded' do
    given_organization_with_opening_plan
    click_link 'Catálogo de Datos'

    expect(page).not_to have_content 'Antes de poder publicar el Catálogo de Datos es necesario haber concluido los siguientes pasos:'
    expect(page).not_to have_content 'Generar Plan de Apertura'
    expect(page).not_to have_content 'Subir el Inventario de Datos'
  end

  def step_link_href_for(link_text)
    find_link(link_text)[:href]
  end
end
