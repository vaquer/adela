class AddMessageToActivityLog < ActiveRecord::Migration
  def change
    add_column :activity_logs, :message, :string
  end
end
