class DataSet
  include ActiveModel::Validations
  attr_accessor :title, :description, :keyword, :modified, :publisher, :contactPoint, :mbox, :identifier, :accessLevel, :accessLevelComment, :accessUrl, :format, :license, :spatial, :temporal

  validates_presence_of :title, :description, :keyword, :modified, :publisher, :contactPoint, :mbox, :identifier, :accessLevel
  validates_presence_of :accessLevelComment, :if => :private?
  validates_presence_of :accessUrl, :if => :public?

  def initialize(attributes = {})
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
    [title, description, keyword, modified, publisher, contactPoint, mbox, identifier, accessLevel, accessLevelComment, accessUrl, format, license, spatial, temporal]
  end

end