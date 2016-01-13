# encoding: UTF-8
module DatasetXLSXBuilder
  extend ActiveSupport::Concern

  module ClassMethods
    def build_from_xlsx_row(catalog, xlsx_row)
      builder = DatasetXLSXBuilder.new(catalog, xlsx_row)
      builder.build
    end

    class DatasetXLSXBuilder
      def initialize(catalog, xlsx_row)
        @xlsx_row = xlsx_row
        @catalog = catalog
        @dataset = catalog.datasets.find_or_initialize_by(title: @xlsx_row[1])
      end

      def build
        build_dataset
        build_distribution
        @dataset.reload
      end

      private

      def build_dataset
        @dataset.update(dataset_metadata)
      end

      def build_distribution
        @dataset.distributions.find_or_initialize_by(title: @xlsx_row[2]).update(distribution_metadata)
      end

      def dataset_metadata
        {
          contact_position: @xlsx_row[0],
          title: @xlsx_row[1],
          publish_date: parse_publish_date,
          public_access: public_dataset?
        }
      end

      def distribution_metadata
        { title: @xlsx_row[2], description: @xlsx_row[3], media_type: @xlsx_row[6] }
      end

      def public_dataset?
        !!(@xlsx_row[4] =~ /P[úu]blico/i)
      end

      def parse_publish_date
        @xlsx_row[7].to_s
      rescue
        nil
      end
    end
  end
end
