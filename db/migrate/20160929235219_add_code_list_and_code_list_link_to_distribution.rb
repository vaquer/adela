class AddCodeListAndCodeListLinkToDistribution < ActiveRecord::Migration
  def change
    add_column :distributions, :codelist, :text
    add_column :distributions, :codelist_link, :string
  end
end
