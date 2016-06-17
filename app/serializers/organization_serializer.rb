class OrganizationSerializer < ActiveModel::Serializer
  attributes :title, :slug, :description, :gov_type, :created_at, :updated_at,
             :imageUrl

  def imageUrl
    "https://raw.githubusercontent.com/mxabierto/assets/master/img/logos/#{object.slug}.png"
  end
end
