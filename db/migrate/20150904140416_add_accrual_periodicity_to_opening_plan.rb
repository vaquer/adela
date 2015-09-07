class AddAccrualPeriodicityToOpeningPlan < ActiveRecord::Migration
  def change
    add_column :opening_plans, :accrual_periodicity, :string
  end
end
