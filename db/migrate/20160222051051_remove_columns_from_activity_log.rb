class RemoveColumnsFromActivityLog < ActiveRecord::Migration
  def change
    remove_column :activity_logs, :done_at, :datetime
    remove_column :activity_logs, :category, :string
  end
end
