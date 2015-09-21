class InventoryElement < ActiveRecord::Base
  # compliant validations
  validate :public_mandatory_fields, unless: :private?
  validate :private_mandatory_fields, if: :private?
  validate :mandatory_fields, :past_publish_date

  validates :inventory, presence: true
  belongs_to :inventory

  private

  def mandatory_fields
    fields = %i(row responsible dataset_title resource_title description private media_type)
    fields.each do |field|
      warnings.add(field) if send(field).nil?
    end
  end

  def public_mandatory_fields
    warnings.add(:publish_date, :blank) if publish_date.nil?
  end

  def private_mandatory_fields
    warnings.add(:access_comment, :blank) if access_comment.nil?
  end

  def past_publish_date
    warnings.add(:publish_date, :past) if publish_date && publish_date.past?
  end
end
