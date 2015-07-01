module DCAT
  module V3
    class DataSet
      include ActiveModel::Validations
      include DCAT::Commons::DataSet
      include DCAT::Commons::Validations
      attr_accessor :landingPage
      validates_url :landingPage, allow_blank: false
    end
  end
end
