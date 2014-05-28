class Distribution
  attr_accessor :spatial, :temporal, :accrualPeriodicity, :title, :description, :downloadURL, :byteSyze, :mediaType

  def initialize(attributes = {})
    attributes.each do |name, value|
      if value.present?
        send("#{name}=", value.force_encoding(Encoding::UTF_8))
      end
    end
  end

  def values_array
    [spatial, temporal, accrualPeriodicity, title, description, downloadURL, mediaType]
  end
end