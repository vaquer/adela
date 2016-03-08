class Distribution < ActiveRecord::Base
  belongs_to :dataset
  validate :mandatory_fields

  before_save :fix_distribution
  before_save :break_distibution
  after_commit :update_dataset_metadata

  state_machine initial: :broke do
    state :broke
    state :documented
    state :published

    event :document do
      transition [:broke, :published] => :documented, if: lambda { |distribution| distribution.compliant? }
    end

    event :break_dist do
      transition [:documented, :published] => :broke, unless: lambda { |distribution| distribution.compliant? }
    end
  end

  private

  def fix_distribution
    document if can_document?
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

  def update_dataset_metadata
    return unless dataset
    last_modified_distribution = dataset.distributions.map(&:modified).compact.sort.last
    dataset.update(modified: last_modified_distribution)
  end
end
