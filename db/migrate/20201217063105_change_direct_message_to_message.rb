class ChangeDirectMessageToMessage < ActiveRecord::Migration[6.0]
  def change
    rename_table :direct_messages, :messages
  end
end
