class DataSet
  include ActiveModel::Validations
  attr_accessor :title, :description, :keyword, :modified, :publisher, :contactPoint, :mbox, :identifier, :accessLevel, :accessLevelComment, :accessUrl

  validates_presence_of :title, :description, :keyword, :modified, :publisher, :contactPoint, :mbox, :identifier, :accessLevel
  validates_presence_of :accessLevelComment, :if => :private?
  validates_presence_of :accessUrl, :if => :public?

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
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
end