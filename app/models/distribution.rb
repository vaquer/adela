class Distribution < ActiveRecord::Base
  belongs_to :dataset
  validate :mandatory_fields

  def mandatory_fields
    fields = %i(download_url temporal modified)
    fields.each do |field|
      warnings.add(field) if send(field).blank?
    end
  end
end
