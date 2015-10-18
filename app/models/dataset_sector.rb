class DatasetSector < ActiveRecord::Base
  belongs_to :sector
  belongs_to :dataset
end
