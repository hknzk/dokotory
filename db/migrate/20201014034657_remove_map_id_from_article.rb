class RemoveMapIdFromArticle < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM articles'
    remove_reference :articles, :map, index: true
  end
end
