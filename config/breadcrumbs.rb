crumb :root do
  link "Inicio", organization_path(current_organization)
end

crumb :planning do
  link "Planea", new_inventory_path(:new_version => true)
  parent :root
end

crumb :catalog do
  link "Último folio", catalog_path(current_organization)
  parent :datasets
end

crumb :datasets do
  link "Catálogo de datos", organization_catalogs_path(current_organization)
end

crumb :dataset do |d|
  link d.title, edit_dataset_path(d)
  parent :datasets
end

crumb :distribution do |r|
  link r.title, edit_distribution_path(r)
  parent :dataset, r.dataset
end
