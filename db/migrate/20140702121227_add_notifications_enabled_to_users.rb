class AddNotificationsEnabledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications_enabled, :boolean, null: false, default: true
  end
end
