class ChangeMapsLatLngToAllowNull < ActiveRecord::Migration[6.0]
  def change
    execute 'DELETE FROM articles'
    execute 'DELETE FROM maps'
    change_column :maps, :lat, :decimal, precision: 9, scale: 6, null:true
    change_column :maps, :lng, :decimal, precision: 9, scale: 6, null:true
  end
end
