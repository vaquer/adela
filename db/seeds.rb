# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

organization = FactoryGirl.create(:organization, title: 'México Abierto', landing_page: 'http://mxabierto.org/')
FactoryGirl.create(:user, organization: organization)

FactoryGirl.create(:sector, title: 'Educación')
FactoryGirl.create(:sector, title: 'Economía')
FactoryGirl.create(:sector, title: 'Salud')
FactoryGirl.create(:sector, title: 'Seguridad y Justicia')
FactoryGirl.create(:sector, title: 'Infraestructura')
FactoryGirl.create(:sector, title: 'Finanzas y Contrataciones')
FactoryGirl.create(:sector, title: 'Geoespacial')
FactoryGirl.create(:sector, title: 'Energía y Medio Ambiente')
FactoryGirl.create(:sector, title: 'Cultura y Turismo')
FactoryGirl.create(:sector, title: 'Desarrollo Sostenible')
FactoryGirl.create(:sector, title: 'Gobiernos Locales')
FactoryGirl.create(:sector, title: 'Otros')
