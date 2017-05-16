class UpdateInvalidDatasetsAccrualPeriodicity < ActiveRecord::Migration
  def change
    Dataset.where(accrual_periodicity: nil).update_all(accrual_periodicity: 'irregular')
  end
end
