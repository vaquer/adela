class CsvFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validator = csv_validator(value)
    unless validator.valid?
      validator.errors.each do |error|
        record.errors[:base] << message(error)
      end
    end
  end

  private
  def csv_validator(csv)
    csv_string = StringIO.new(csv.read.to_utf8)
    Csvlint::Validator.new(csv_string) 
  end

  def message(error)
    I18n.t("activerecord.errors.models.inventory.attributes.csv_file.#{error.type.to_s}", row: error.row)
  end
end
