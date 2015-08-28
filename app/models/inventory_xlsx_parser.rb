# encoding: UTF-8
class InventoryXLSXParser
  attr_reader :inventory

  def initialize(inventory)
    @inventory = inventory
  end

  def parse
    xlsx = Roo::Spreadsheet.open(inventory.spreadsheet_file)
    (xlsx.first_row..xlsx.last_row).drop(1).map do |i|
      xlsx_row = xlsx.row(i)
      build_inventory_row(xlsx_row, i)
    end
  end

  private

  def build_inventory_row(xlsx_row, row_number)
    InventoryRow.new(
      number: row_number,
      responsible: xlsx_row[0],
      dataset_title: xlsx_row[1],
      resource_title: xlsx_row[2],
      dataset_description: xlsx_row[3],
      private_data: parse_private_data(xlsx_row),
      data_access_comment: xlsx_row[5],
      media_type: xlsx_row[6],
      publish_date: xlsx_row[7].to_s
    )
  end

  def parse_private_data(xlsx_row)
    xlsx_row[4] =~ /P[úu]blico/i ? false : true
  end
end
