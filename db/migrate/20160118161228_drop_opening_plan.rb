class DropOpeningPlan < ActiveRecord::Migration
  def change
    drop_table :opening_plans
  end
end
