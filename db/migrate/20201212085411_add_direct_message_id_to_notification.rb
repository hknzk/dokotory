class AddDirectMessageIdToNotification < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :direct_message, index: true, null: true
  end
end
