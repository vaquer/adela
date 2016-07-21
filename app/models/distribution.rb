class Distribution < ActiveRecord::Base
  include Versionable

  belongs_to :dataset
  audited associated_with: :dataset

  validate :mandatory_fields

  validates_uniqueness_of :title
  validates_uniqueness_of :download_url, allow_nil: true

  has_one :catalog, through: :dataset
  has_one :organization, through: :dataset

  before_save :fix_distribution
  before_save :break_distibution

  before_save :break_published_distribution
  before_save :fix_published_distribution

  after_commit :update_dataset_metadata

  state_machine initial: :broke do
    state :broke
    state :documented
    state :refining
    state :refined
    state :published

    event :document do
      transition [:broke] => :documented, if: lambda { |distribution| distribution.compliant? }
    end

    event :break_dist do
      transition [:documented] => :broke, unless: lambda { |distribution| distribution.compliant? }
    end

    event :break_published_dist do
      transition [:published] => :refining, unless: lambda { |distribution| distribution.compliant? }
    end

    event :refine_published_dist do
      transition [:published, :refining] => :refined, if: lambda { |distribution| distribution.compliant? }
    end
  end

  def as_csv(options = {})
    if options[:style] == :inventory
      {
        'Responsable': dataset.contact_position,
        'Nombre del conjunto': dataset.title,
        'Nombre del recurso': title,
        '¿De qué es?': description,
        '¿Tiene datos privados?': dataset.public_access ? 'Publico' : 'Privado',
        'Razón por la cual los datos son privados': nil,
        '¿En qué plataforma, tecnología, programa o sistema se albergan?': media_type,
        'Fecha estimada de publicación en datos.gob.mx': dataset.publish_date&.strftime('%F')
      }
    else
      attributes
    end
  end

  private

  def fix_distribution
    document if can_document?
  end

  def fix_published_distribution
    break_published_dist if can_break_published_dist?
  end

  def break_distibution
    break_dist if can_break_dist?
  end

  def break_published_distribution
    refine_published_dist if can_refine_published_dist?
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
