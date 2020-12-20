class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :visitor, index:true, null: false, foreign_key: {to_table: :users}
      t.references :visited, index:true, null: false, foreign_key: {to_table: :users}
      t.references :message, index: true, null: true
      t.references :favorite, index: true, null: true
      t.references :direct_message, index: true, null: true
      t.integer :action, null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
