module DCAT
  module V2
    class DataSet
      include ActiveModel::Validations
      include DCAT::Commons::DataSet
      include DCAT::Commons::Validations
      attr_accessor :dataDictionary
      validates_url :dataDictionary, allow_blank: true
    end
  end
end
