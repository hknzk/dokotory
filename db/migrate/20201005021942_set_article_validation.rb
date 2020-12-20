class SetArticleValidation < ActiveRecord::Migration[6.0]
  def change
    change_column_null :articles, :name, null: false
    change_column_null :articles, :body, null: false
  end
end
