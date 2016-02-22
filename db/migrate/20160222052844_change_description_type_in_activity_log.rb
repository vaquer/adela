class ChangeDescriptionTypeInActivityLog < ActiveRecord::Migration
  def change
    change_column :activity_logs, :description, :text
  end
end
