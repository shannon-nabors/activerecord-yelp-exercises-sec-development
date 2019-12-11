class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.text :content
      t.integer :rating
      t.datetime :date
      t.integer :customer_id
      t.integer :restaurant_id
    end
  end
end
