require 'spec_helper'

feature "data catalog management" do
  
  background do
    @organization = FactoryGirl.create(:organization)
    @success_response = [
      {
        "title"=>"Presupuesto de egresos 2013",
        "description"=>"Presupuesto de Egresos de la Federación para el 2013.",
        "modified"=>"20130222T10:00:00Z",
        "publisher"=>"SHCP",
        "contactPoint"=>"Juan Arcadio García Márquez",
        "mbox"=>"datos@shcp.gob.mx",
        "identifier"=>"pef2013_1",
        "accessLevel"=>"público",
        "accessLevelComment"=>nil,
        "format"=>"csv",
        "license"=>"http://creativecommons.org/licenses/by/2.5/mx/deed.en_US",
        "spatial"=>"32.71862,-114.700699,30.859409,-115.818169",
        "temporal"=>"20130101T00:00:00Z/20140101T00:00:00Z",
        "keyword"=>["presupuesto", "egreso"],
        "accessUrl"=>"http://www.transparenciapresupuestaria.gob.mx/ptp/ServletImagen?tipo=csv&idDoc=711"
      }, 
      {
        "title"=>"Recetas médicas de Octubre",
        "description"=>"Recetas médicas entregadas por todas las delegaciones en el mes de octubre de 2013.",
        "modified"=>"20131101T10:00:00Z",
        "publisher"=>"IMSS",
        "contactPoint"=>"Gabriel Buendía",
        "mbox"=>"datos@imss.gob.mx",
        "identifier"=>"recetas201310",
        "accessLevel"=>"privado",
        "accessLevelComment"=>"La base de datos contiene información personal. Para fines estadísticos se podrá encontrar una versión con datos acumulados en http://www.imss.gob.mx/datos/201310/nacional/recetasAcumuladas.csv, y una versión anonimizada en http://www.imss.gob.mx/datos/201310/nacional/recetasAnonimizadas.csv",
        "format"=>"xls",
        "license"=>nil,
        "spatial"=>"nacional",
        "temporal"=>"20131101T00:00:00Z/20131130T00:00:00Z",
        "keyword"=>["salud", "imss", "recetas"]
      }
    ]
    @empty_response = []
  end

  scenario "can consume published catalog data" do
    given_there_is_a_catalog_published 10.days.ago
    get "/#{@organization.slug}/catalogo.json"
    gets_catalog_json_data_in response
  end

  scenario "can't consume unpublished catalog data" do
    given_there_is_an_inventary_by("CONEVAL", "unpublished")
    get "/coneval/catalogo.json"
    gets_empty response
  end

  scenario "can see all the catalogs available through the api" do
    given_there_is_an_inventary_by("CONEVAL", "published")
    given_there_is_an_inventary_by("Presidencia", "published")
    given_there_is_an_inventary_by("Hacienda", "unpublished")
    get "/api/v1/organizations/catalogs.json"
    gets_all_catalogs_urls_in response
  end

  def given_there_is_a_catalog_published(days_ago)
    @inventory = FactoryGirl.create(:published_inventory, :publish_date => days_ago)
    @inventory.update_attributes(:organization_id => @organization.id)
  end

  def gets_catalog_json_data_in(response)
    json_response = JSON.parse(response.body)
    json_response.should == @success_response
  end

  def gets_empty(response)
    json_response = JSON.parse(response.body)
    json_response.should == @empty_response
  end

  def given_there_is_an_inventary_by(organization_title, status)
    organization = FactoryGirl.create(:organization, :title => organization_title)
    case status
    when "published"
      inventory = FactoryGirl.create(:published_inventory)
    when "unpublished"
      inventory = FactoryGirl.create(:inventory)
    end
    inventory.update_attributes(:organization_id => organization.id)
  end

  def gets_all_catalogs_urls_in(response)
    json_response = JSON.parse(response.body)
    json_response.size.should == 2
  end
end