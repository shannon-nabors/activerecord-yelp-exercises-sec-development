require_relative '../config/environment.rb'

Restaurant.destroy_all
Dish.destroy_all
Tag.destroy_all
DishTag.destroy_all

restaurants = ["Chipotle", "Strapazza", "Columbia Alehouse", "Eggspectations", "Chopt", "KFC", "La Malinche", "McDonalds", "Lebanese Taverna", "Roti", "District Taco", "Cava", "Mod Pizza", "Red Lobster", "Hunan Manor", "House of India", "Bollywood Masala", "La Palapa Too", "Uncle Julio's", "McGinty's"]

dishes = ["Hamburger", "Fish Tacos", "Sesame Chicken", "Chicken Korma", "Falafel", "Dumplings", "Reuben Sandwich", "French Fries", "Rice Bowl", "Fish and Chips", "Chicken Tikka Masala", "Samosas", "Chicken Sandwich", "Patatas Bravas", "Vegetable Omelet", "Spaghetti", "Caesar Salad", "Spinach Ravioli", "Steak Fajitas", "Pepperoni Pizza", "Fried Rice", "Cheese Pizza", "Palak Paneer", "Drumsticks", "Shrimp Scampi", "Chips and Guacamole"]

tags = ["Vegetarian", "Spicy", "Side Dish", "Breakfast", "Seafood", "Italian", "Indian", "Fast Food", "Small Plates", "Sandwiches", "Pizza", "Classics", "Healthy", "Pub Fare", "Shareable", "Appetizer", "Dessert", "Main Dish"]

restaurants.each { |n| Restaurant.create(name: n) }

Restaurant.all.each do |r|
    dishes.sample(10).each do |dish|
        Dish.create(name: dish, restaurant_id: r.id)
    end
end

tags.each { |n| Tag.create(name: n) }

Dish.all.each do |d|
    Tag.all.sample(3).each do |t|
        DishTag.create(dish_id: d.id, tag_id: t.id)
    end
end

