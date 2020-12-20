class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|

      t.timestamps
      t.text :body, null: false
      t.references :user, foreign_key: true
      t.references :article, foreign_key: true
    end
  end
end
