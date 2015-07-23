class Distribution
  include ActiveModel::Validations

  attr_accessor :title, :description, :downloadURL, :mediaType, :format,
                :byteSize, :temporal, :spatial

  validates_url :downloadURL, allow_blank: false

  def initialize(attributes = {})
    attributes.each do |name, value|
      if value.present?
        send("#{name}=", value.force_encoding(Encoding::UTF_8))
      end
    end
  end
end
