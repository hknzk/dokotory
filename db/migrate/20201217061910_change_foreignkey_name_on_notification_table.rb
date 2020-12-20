class ChangeForeignkeyNameOnNotificationTable < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM notifications'
    remove_column :notifications, :message_id, null: true
    remove_column :notifications, :direct_message_id, null: true

    add_column :notifications, :comment_id, :integer, null: true
    add_column :notifications, :message_id, :integer, null:true
    add_index :notifications, :comment_id
    add_index :notifications, :message_id

  end
end
