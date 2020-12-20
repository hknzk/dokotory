class CreateMaps < ActiveRecord::Migration[6.0]
  def change
    create_table :maps do |t|
      t.boolean :is_enabled, null:false, default: false
      t.decimal :lat, precision: 9, scale: 6, null: false
      t.decimal :lng, precision: 9, scale: 6, null: false
      t.references :article, foreign_key: true

      t.timestamps
    end
  end
end
