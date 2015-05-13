class KeywordsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.map do |keyword|
      unless invalid_characters?(keyword)
        record.errors[:base] << I18n.t("activemodel.errors.models.data_set.attributes.keyword.invalid_characters")
      end
    end
  end

  private

  def invalid_characters?(keyword)
    keyword.scan(/[^[[:alnum:]][[:space:]]\.\-_]/).blank?
  end
end
