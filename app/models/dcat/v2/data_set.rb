module DCAT
  module V2
    class DataSet
      include ActiveModel::Validations
      include DCAT::Commons

      attr_accessor :distributions, :publisher, :identifier, :title, :description,
        :keyword, :modified, :contactPoint, :mbox, :accessLevel, :accessLevelComment,
        :temporal, :spatial, :dataDictionary, :accrualPeriodicity

      validates_presence_of :accessLevelComment, if: :private?
      validates :keywords, keywords: true
      validate :distributions_download_url, if: :public?

      private

      def distributions_download_url
        unless download_url?
          errors.add(:distributions)
        end
      end
    end
  end
end
