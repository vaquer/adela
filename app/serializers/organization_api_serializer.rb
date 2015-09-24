class OrganizationAPISerializer < ActiveModel::Serializer
  has_many :results, each_serializer: OrganizationSerializer
  attributes :results, :pagination

  def results
    object
  end

  def pagination
    {
      page: object.current_page,
      per_page: object.per_page,
      total: object.total_entries
    }
  end
end
