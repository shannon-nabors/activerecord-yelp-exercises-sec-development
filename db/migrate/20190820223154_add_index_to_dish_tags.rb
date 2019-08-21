class AddIndexToDishTags < ActiveRecord::Migration[5.2]
  def change
    add_index :dish_tags, [:dish_id, :tag_id], unique: true
  end
end
