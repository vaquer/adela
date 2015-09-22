class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :title

      t.timestamps
    end
  end
end
