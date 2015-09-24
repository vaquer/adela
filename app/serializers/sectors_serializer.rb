class SectorsSerializer < ActiveModel::Serializer
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
