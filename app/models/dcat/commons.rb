module DCAT
  module Commons

    def initialize(attributes = {})
      @distributions = []
      attributes.each do |name, value|
        if value.present?
          send("#{name}=", value.force_encoding(Encoding::UTF_8).strip)
        end
      end
    end

    def private?
      ['privado', 'restringido'].include? accessLevel
    end

    def public?
      ['público'].include? accessLevel || accessLevel.blank?
    end

    def keywords
      keyword.to_s.split(",").map(&:strip).reject{ |k| k.empty? }
    end

    def distributions_count
      distributions.size
    end

    private

    def distributions_structure
      unless valid_distributions?
        errors.add(:distributions)
      end
    end

    def valid_distributions?
      distributions.inject { |memo, distribution| memo && distribution.valid? }
    end
  end
end
