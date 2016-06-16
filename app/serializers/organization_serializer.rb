class OrganizationSerializer < ActiveModel::Serializer
  attributes :title, :slug, :description, :gov_type, :created_at, :updated_at
end
