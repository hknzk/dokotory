class FixNotification < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM notifications'

    remove_reference :notifications, :visitor, index: true, null: false
    remove_reference :notifications, :visited, index: true, null: false
    remove_reference :notifications, :message, index: true, null: true
    remove_reference :notifications, :article, index: true, null: true
    remove_reference :notifications, :direct_message, index: true, null: true

    add_column :notifications, :visitor_id, :integer, null: false
    add_column :notifications, :visited_id, :integer, null: false
    add_column :notifications, :article_id, :integer, null: true
    add_column :notifications, :message_id, :integer, null: true
    add_column :notifications, :direct_message_id, :integer, null: true

    add_index :notifications, :visitor_id
    add_index :notifications, :visited_id
    add_index :notifications, :article_id
    add_index :notifications, :message_id
    add_index :notifications, :direct_message_id
  end
end
