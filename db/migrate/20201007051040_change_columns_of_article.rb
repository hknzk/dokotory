class ChangeColumnsOfArticle < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :type, :string
    remove_column :articles, :status, :string
    add_column :articles, :is_published, :boolean, null: false, default: false
    add_column :articles, :is_resolved, :boolean, null: false, default: false
  end
end
