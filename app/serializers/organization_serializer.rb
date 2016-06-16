class OrganizationSerializer < ActiveModel::Serializer
  attributes :title, :slug, :description, :govType, :created_at, :updated_at,
             :imageUrl

  def govType
    object.gov_type
  end

  def imageUrl
    "https://raw.githubusercontent.com/mxabierto/assets/master/img/logos/#{object.slug}.png"
  end
end
