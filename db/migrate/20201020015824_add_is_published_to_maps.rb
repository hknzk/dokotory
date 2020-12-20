class AddIsPublishedToMaps < ActiveRecord::Migration[6.0]
  def change
    add_column :maps, :is_article_published, :boolean, null: false, default: false
  end
end
