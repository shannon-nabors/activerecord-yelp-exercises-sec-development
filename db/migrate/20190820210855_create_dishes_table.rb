class CreateDishesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.integer :restaurant_id
      t.decimal :price
      t.decimal :cost
    end
  end
end
