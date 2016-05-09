# encoding: utf-8

organization = create(:organization, title: 'México Abierto', landing_page: 'http://mxabierto.org/')
create(:user, organization: organization)

create(:sector, title: 'Educación')
create(:sector, title: 'Economía')
create(:sector, title: 'Salud')
create(:sector, title: 'Seguridad y Justicia')
create(:sector, title: 'Infraestructura')
create(:sector, title: 'Finanzas y Contrataciones')
create(:sector, title: 'Geoespacial')
create(:sector, title: 'Energía y Medio Ambiente')
create(:sector, title: 'Cultura y Turismo')
create(:sector, title: 'Desarrollo Sostenible')
create(:sector, title: 'Gobiernos Locales')
create(:sector, title: 'Otros')
