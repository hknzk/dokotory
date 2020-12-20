class AddColumnsToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :condition, :text, null: false
    add_column :articles, :species, :string, null: false
    add_column :articles, :prefecture, :string, null: false
    add_column :articles, :municipality, :string, null: false
    add_column :articles, :type, :string, null: false
    add_column :articles, :status, :string, null: false
  end
end
