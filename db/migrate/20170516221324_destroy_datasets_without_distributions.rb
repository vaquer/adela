class DestroyDatasetsWithoutDistributions < ActiveRecord::Migration
  def change
    Dataset.includes(:distributions).where(distributions: { id: nil }).destroy_all
  end
end
