class CsvFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors[:base] << I18n.t("activerecord.errors.models.inventory.attributes.csv_file.blank_file")
    else
      csvlint_validations(record, value)
    end
  end

  private
  def csvlint_validations(record, value)
    validator = csvlint_validator(value)
    unless validator.valid?
      validator.errors.each do |error|
        record.errors[:base] << message(error)
      end
    end
  end

  def csvlint_validator(csv)
    csv_string = StringIO.new(csv.read.to_utf8)
    Csvlint::Validator.new(csv_string) 
  end

  def message(error)
    I18n.t("activerecord.errors.models.inventory.attributes.csv_file.#{error.type.to_s}", row: error.row)
  end
end
