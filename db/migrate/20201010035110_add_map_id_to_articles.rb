class AddMapIdToArticles < ActiveRecord::Migration[6.0]
  def up
    add_reference :articles, :map, index: true, null:false
  end

  def down
    remove_reference :articles, :map, index: true
  end
end
