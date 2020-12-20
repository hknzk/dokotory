class NotAllowFavoriteArticleIdToBeNull < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM favorites;'
    remove_reference :favorites, :article, index: true
    add_reference :favorites, :article, index: true, null: false
  end
end
