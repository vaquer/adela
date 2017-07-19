class DestroyDatasetsWithoutDistributions < ActiveRecord::Migration
  class Dataset < ActiveRecord::Base
  end

  def change
    Dataset.includes(:distributions).where(distributions: { id: nil }).destroy_all
  end
end
