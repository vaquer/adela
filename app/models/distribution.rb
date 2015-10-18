class Distribution < ActiveRecord::Base
  belongs_to :dataset
  validate :mandatory_fields

  before_save :fix_distribution
  before_save :break_distibution

  state_machine initial: :broke do
    state :broke
    state :validated
    state :published

    event :validate do
      transition [:broke, :published] => :validated, if: lambda { |distribution| distribution.compliant? }
    end

    event :break_dist do
      transition [:validated, :published] => :broke, unless: lambda { |distribution| distribution.compliant? }
    end
  end

  private

  def fix_distribution
    validate if can_validate?
  end

  def break_distibution
    break_dist if can_break_dist?
  end

  def mandatory_fields
    fields = %i(download_url temporal modified)
    fields.each do |field|
      warnings.add(field) if send(field).blank?
    end
  end
end
