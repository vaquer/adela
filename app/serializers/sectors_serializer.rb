class SectorsSerializer < ActiveModel::Serializer
  attributes :results, :pagination

  def results
    object
  end

  def pagination
    {
      count: object.size,
      page: object.current_page,
      per_page: object.per_page,
    }
  end
end
