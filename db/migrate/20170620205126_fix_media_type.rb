class FixMediaType < ActiveRecord::Migration
  def change
    Distribution.where("media_type ILIKE 'csv'").each do |distribution|
      distribution.update_columns(media_type: 'text/csv', format: 'csv')
    end

    Distribution.where("media_type ILIKE 'Excel (Delimitado por comas)'").each do |distribution|
      distribution.update_columns(media_type: 'text/csv', format: 'csv')
    end

    Distribution.where("media_type ILIKE 'CSV, EXCEL'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'Documento Excel.'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'excel CSV'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'excel'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'excell'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'excel '").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'MS Excel'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'Recurso contenido en Excel'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'xls'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'xlsx'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.ms-excel', format: 'xls')
    end

    Distribution.where("media_type ILIKE 'json'").each do |distribution|
      distribution.update_columns(media_type: 'application/json', format: 'json')
    end

    Distribution.where("media_type ILIKE 'kml'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.google-earth.kml+xml', format: 'kml')
    end

    Distribution.where("media_type ILIKE 'shp'").each do |distribution|
      distribution.update_columns(media_type: '', format: 'shp')
    end

    Distribution.where("media_type ILIKE 'shape'").each do |distribution|
      distribution.update_columns(media_type: '', format: 'shp')
    end

    Distribution.where("media_type ILIKE 'kmz'").each do |distribution|
      distribution.update_columns(media_type: 'application/vnd.google-earth.kmz', format: 'kmz')
    end

    Distribution.where('format IS NULL').each do |distribution|
      new_format = distribution.media_type
      distribution.update_columns(media_type: '', format: new_format)
    end
  end
end
