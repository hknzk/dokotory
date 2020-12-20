class RemoveIsVisitorAndAddUserIdToMessage < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM messages;'
    remove_column :messages, :is_visitor, :boolean
    add_reference :messages, :user, null: false
  end
end
