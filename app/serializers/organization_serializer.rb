class OrganizationSerializer < ActiveModel::Serializer
  attributes :title, :slug, :description, :logo_url, :gov_type, :created_at, :updated_at
end
