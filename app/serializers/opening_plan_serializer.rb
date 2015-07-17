class OpeningPlanSerializer < ActiveModel::Serializer
  has_many :officials, each_serializer: OfficialSerializer
  attributes :vision, :name, :description, :publish_date
end
