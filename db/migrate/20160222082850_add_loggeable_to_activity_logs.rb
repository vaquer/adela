class AddLoggeableToActivityLogs < ActiveRecord::Migration
  def change
    add_reference :activity_logs, :loggeable, polymorphic: true, index: true
  end
end
