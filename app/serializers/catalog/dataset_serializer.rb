class Catalog::DatasetSerializer < DatasetSerializer
  has_many :distributions, root: :distribution, serializer: DistributionSerializer

  def distributions
    object.distributions.select(&:issued?)
  end
end
