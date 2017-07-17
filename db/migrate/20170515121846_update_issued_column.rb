class UpdateIssuedColumn < ActiveRecord::Migration
  def change
    def data_fusion_query(dataset_id)
      url = "https://api.datos.gob.mx/v1/data-fusion?id=#{dataset_id}"
      response = HTTParty.get(url)

      JSON.parse(response.body)
    rescue SocketError => e
      puts e
      sleep 10
      retry
    end

    Dataset.find_each do |dataset|
      data_fusion_results = data_fusion_query(dataset.id)['results']
      next if data_fusion_results.blank?

      ckan_dataset = data_fusion_results.first['ckan']['dataset']
      next unless ckan_dataset

      issued = ckan_dataset['metadata-modified']
      next unless issued

      dataset.update_column(:issued, issued)
      dataset.distributions.where(
        state: [
          'published',
          'refined',
          'refining'
        ]
      ).update_all(issued: issued)
    end
  end
end
