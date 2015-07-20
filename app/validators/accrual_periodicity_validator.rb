class AccrualPeriodicityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless valid?(value)
      record.warnings[:accrualPeriodicity] << I18n.t("activerecord.errors.models.data_set.attributes.accrualPeriodicity.repeating_duration")
    end
  end

  private

  def valid?(input)
    input.present? && regex_match(input)
  end

  def regex_match(input)
    irregular?(input) || iso_8601_repeating_duration?(input)
  end

  def irregular?(input)
    input.match(/^irregular$/i).present?
  end

  def iso_8601_repeating_duration?(input)
    match_data = match_iso_8601_repeating_duration(input)
    match_data.present? && match_data.captures.compact.present?
  end

  def match_iso_8601_repeating_duration(input)
    input.match(
      /^
        R(?:
          (?:
            (?:(?<repetitions>\d+))?
          )
        )\/
        (?<sign>\+|-)?
        P(?:
          (?:
            (?:(?<years>\d+(?:[,.]\d+)?)Y)?
            (?:(?<months>\d+(?:[.,]\d+)?)M)?
            (?:(?<days>\d+(?:[.,]\d+)?)D)?
            (?<time>T
              (?:(?<hours>\d+(?:[.,]\d+)?)H)?
              (?:(?<minutes>\d+(?:[.,]\d+)?)M)?
              (?:(?<seconds>\d+(?:[.,]\d+)?)S)?
            )?
          ) |
          (?<weeks>\d+(?:[.,]\d+)?W)
        )
      $/x
    )
  end
end
