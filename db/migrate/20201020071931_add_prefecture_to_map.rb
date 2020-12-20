class AddPrefectureToMap < ActiveRecord::Migration[6.0]
  def change
    add_column :maps, :prefecture, :string, null: false
  end
end
