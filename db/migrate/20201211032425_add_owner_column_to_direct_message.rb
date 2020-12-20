class AddOwnerColumnToDirectMessage < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM direct_messages'
    add_column :direct_messages, :owner, :integer, default: 0
  end
end
