module OpeningPlansHelper
  def iso8601_repeating_interval_options_for_select(default)
    options_for_select(iso8601_options, default)
  end

  def parse_iso8601(iso8601)
    ISO8601_DEFAULTS['accrual_periodicity'].key(iso8601).humanize
  end

  private

  def iso8601_options
    ISO8601_DEFAULTS['accrual_periodicity'].map{ |key, value| [key.humanize, value] }
  end
end
