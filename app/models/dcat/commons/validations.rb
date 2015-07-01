module DCAT
  module Commons
    module Validations
      extend ActiveSupport::Concern

      included do
        validates_presence_of :accessLevelComment, :if => :private?
        validates :keywords, keywords: true
        validates :accrualPeriodicity, accrualPeriodicity: true
        validate  :distributions_structure
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
end
