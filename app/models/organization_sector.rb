class OrganizationSector < ActiveRecord::Base
  belongs_to :organization
  belongs_to :sector
end
