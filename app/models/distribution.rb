class Distribution < ActiveRecord::Base
  include Versionable
  include Publishable

  belongs_to :dataset
  audited associated_with: :dataset

  validate :mandatory_fields

  validates_uniqueness_of :title
  validates_uniqueness_of :download_url, allow_nil: true

  has_one :catalog, through: :dataset
  has_one :organization, through: :dataset

  after_commit :update_dataset_metadata

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
