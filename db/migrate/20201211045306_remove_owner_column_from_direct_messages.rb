class RemoveOwnerColumnFromDirectMessages < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM direct_messages'
    remove_column :direct_messages, :owner, :integer
  end
end
