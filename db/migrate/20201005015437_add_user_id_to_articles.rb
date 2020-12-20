class AddUserIdToArticles < ActiveRecord::Migration[6.0]
  def up
    add_reference :articles, :user, index: true, null:false
  end

  def down
    remove_reference :articles, :user, index: true
  end
end
