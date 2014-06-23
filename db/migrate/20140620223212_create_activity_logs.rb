class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.integer   :organization_id
      t.string    :description
      t.datetime  :done_at
      t.timestamps
    end
  end
end
