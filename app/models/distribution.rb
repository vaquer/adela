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
