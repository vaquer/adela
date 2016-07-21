crumb :root do
  link 'Adela', organization_path(current_organization) if current_organization
end

crumb :inventory do
  link 'Plan de Apertura Institucional', inventories_datasets_path
  parent :root
end

crumb :inventory_new_dataset do
  link 'Agregar un Conjunto de Datos'
  parent :inventory
end

crumb :inventory_edit_dataset do
  link 'Editar un Conjunto de Datos'
  parent :inventory
end

crumb :inventory_edit_distribution do
  link 'Editar un Recurso de Datos'
  parent :inventory
end

crumb :inventory_new_distribution do
  link 'Agregar un Recurso de Datos'
  parent :inventory
end

crumb :catalog do
  link 'Catálogo de Datos', organization_catalogs_path(current_organization)
  parent :root
end

crumb :catalog_dataset do
  link 'Documentar un Conjunto de Datos'
  parent :catalog
end

crumb :catalog_distribution do
  link 'Documentar un Recurso de Datos'
  parent :catalog_dataset
end

crumb :documents do
  link 'Documentos', inventories_datasets_path
  parent :root
end
