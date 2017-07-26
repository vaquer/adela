class SplitTemporalData < ActiveRecord::Migration
  class Dataset < ActiveRecord::Base
  end

  class Distribution < ActiveRecord::Base
  end
  
  def change
    Dataset.where.not(temporal: nil).map do |dataset|
      begin
        temporal = dataset[:temporal].split('/').map do |date|
          ISO8601::Date.new(date)
        end

        next if temporal.size != 2

        dataset.update(
          temporal_init_date: temporal[0].to_s,
          temporal_init_date: temporal[1].to_s
        )
      rescue => error
        puts error
        next
      end
    end

    Distribution.where.not(temporal: nil).map do |distribution|
      begin
        temporal = distribution[:temporal].split('/').map do |date|
          ISO8601::Date.new(date)
        end

        next if temporal.size != 2

        distribution.update(
          temporal_init_date: temporal[0].to_s,
          temporal_init_date: temporal[1].to_s
        )
      rescue => error
        puts error
        next
      end
    end
  end
end
