class RemoveReferencesFromNotification < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifications, :direct_message, index: true
    remove_reference :notifications, :favorite, index: true
    add_reference :notifications, :article, index: true, null: true
  end
end
