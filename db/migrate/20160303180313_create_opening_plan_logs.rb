class CreateOpeningPlanLogs < ActiveRecord::Migration
  def change
    create_table :opening_plan_logs do |t|
      t.references :organization, index: true, foreign_key: true
      t.json :opening_plan

      t.timestamps null: false
    end
  end
end
