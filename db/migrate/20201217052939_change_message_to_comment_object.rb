class ChangeMessageToCommentObject < ActiveRecord::Migration[6.0]
  def change
    rename_table :messages, :comments
  end
end
