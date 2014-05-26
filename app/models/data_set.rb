class DataSet
  include ActiveModel::Validations
  attr_accessor :distributions, :title, :description, :keyword, :publisher, :modified, :publisher, :contactPoint, :mbox, :identifier, :accessLevel, :accessLevelComment, :license, :spatial

  validates_presence_of :accessLevelComment, :if => :private?
  validate :distributions_download_url, :if => :public?

  def initialize(attributes = {})
    @distributions = []
    attributes.each do |name, value|
      if value.present?
        send("#{name}=", value.force_encoding(Encoding::UTF_8))
      end
    end
  end

  def private?
    ["privado", "restringido"].include? accessLevel
  end

  def public?
    ["público"].include? accessLevel
  end

  def persisted?
    false
  end

  def keywords
    keyword.split(",")
  end

  def values_array
    [identifier, title, description, keyword, modified, contactPoint, mbox, accessLevel, accessLevelComment, license, spatial]
  end

  def download_url?
    distributions.all? { |distribution| distribution.downloadURL.present? }
  end

  def distributions_download_url
    unless download_url?
      errors.add(:distributions)
    end
  end
end