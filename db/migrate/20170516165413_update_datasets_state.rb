class UpdateDatasetsState < ActiveRecord::Migration
  def change
    Dataset.where.not(issued: nil).update_all(state: 'published')
    Dataset.where(state: nil).update_all(state: 'broke')
    Dataset.where(state: 'broke').map(&:document)
  end
end
