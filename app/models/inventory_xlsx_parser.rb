# encoding: UTF-8
class InventoryXLSXParser
  attr_reader :inventory

  def initialize(inventory)
    @inventory = inventory
  end

  def parse
    begin
      xlsx = Roo::Spreadsheet.open(inventory_file_path)
      (xlsx.first_row..xlsx.last_row).drop(1).map do |i|
        xlsx_row = xlsx.row(i)
        create_inventory_element(xlsx_row, i)
      end
    rescue => e
      @inventory.error_message = e.message
      @inventory.save
    end
  end

  private

  def inventory_file_path
    Rails.env.production? ? @inventory.spreadsheet_file.url : @inventory.spreadsheet_file
  end

  def create_inventory_element(xlsx_row, row)
    @inventory.inventory_elements.create do |element|
      element.row = row
      element.responsible = xlsx_row[0]
      element.dataset_title = xlsx_row[1]
      element.resource_title = xlsx_row[2]
      element.description = xlsx_row[3]
      element.private = parse_private_data(xlsx_row)
      element.access_comment = xlsx_row[5]
      element.media_type = xlsx_row[6]
      element.publish_date = parse_publish_date(xlsx_row)
    end
  end

  def parse_private_data(xlsx_row)
    xlsx_row[4] =~ /P[úu]blico/i ? false : true
  end

  def parse_publish_date(xlsx_row)
    publish_date = xlsx_row[7].to_s
    ISO8601::Date.new(publish_date) if matches_iso8601?(publish_date)
  end

  def matches_iso8601?(publish_date)
    publish_date =~ /^(\d{4})-(\d{2})/
  end
end
