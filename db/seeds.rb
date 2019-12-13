require_relative '../config/environment.rb'

Restaurant.destroy_all
Dish.destroy_all
Tag.destroy_all
DishTag.destroy_all
Order.destroy_all
Customer.destroy_all
Review.destroy_all
OrderDish.destroy_all

############################################################

restaurants = ["Chipotle", "Strapazza", "Columbia Alehouse", "Eggspectations", "Chopt", "KFC", "La Malinche", "McDonald's", "Lebanese Taverna", "Roti", "District Taco", "Cava", "Mod Pizza", "Red Lobster", "Hunan Manor", "House of India", "Bollywood Masala", "La Palapa Too", "Uncle Julio's", "McGinty's"]
dishes = ["Hamburger", "Fish Tacos", "Sesame Chicken", "Chicken Korma", "Falafel", "Dumplings", "Reuben Sandwich", "French Fries", "Rice Bowl", "Fish and Chips", "Chicken Tikka Masala", "Samosas", "Chicken Sandwich", "Patatas Bravas", "Vegetable Omelet", "Spaghetti", "Caesar Salad", "Spinach Ravioli", "Steak Fajitas", "Pepperoni Pizza", "Fried Rice", "Cheese Pizza", "Palak Paneer", "Drumsticks", "Shrimp Scampi", "Chips and Guacamole"]
tags = ["Vegetarian", "Spicy", "Side Dish", "Breakfast", "Seafood", "Italian", "Indian", "Fast Food", "Small Plates", "Sandwiches", "Pizza", "Classics", "Healthy", "Pub Fare", "Shareable", "Appetizer", "Dessert", "Main Dish"]
customers = ["Shannon Nabors", "JC Chang", "Chine Anikwe", "Trevor Jameson", "Joseph Arias", "Jenny Ingram", "Paul Nicholsen", "Ann Duong", "Bruno Garcia Gonzalez", "Su Kim", "Josh Daniell", "Ammar Ali", "Jonnel Benjamin"]

############################################################

def generate_cost(price)
    (price - rand(0.1..price-0.1)).round(2)
end

def latitude
    rand(38.0..40.0)
end

def longitude
    rand(76.0..78.0)
end

def add_dishes_to_order(restaurant_dishes, customer_id, restaurant_id)
    order = Order.new(customer_id: customer_id, restaurant_id: restaurant_id)
    dishes = restaurant_dishes.sample(rand(1..5))
    dishes.each do |dish|
        order.dishes << dish
    end
    order.save
end

def write_review
    review = "blah"
    rand(0..50).times do
        review += " blah"
    end
    return review
end

def opinions?
    rand(1..4) < 4
end

def recent_date
    Time.now - rand(10000..1000000)
end

############################################################

restaurants.each do |n| 
    Restaurant.create(name: n, lat: latitude, lon: longitude)
end

customers.each do |n|
    Customer.create(name: n, lat: latitude, lon: longitude)
end

Restaurant.all.each do |restaurant|
    dishes.sample(rand(1..25)).each do |dish|
        price = rand(1.5..40).round(2)
        cost = generate_cost(price)
        Dish.create(name: dish, restaurant_id: restaurant.id, price: price, cost: cost)
    end
end

tags.each { |n| Tag.create(name: n) }

Dish.all.each do |dish|
    Tag.all.sample(rand(0..5)).each do |tag|
        DishTag.create(dish_id: dish.id, tag_id: tag.id)
    end
end

50.times do
    customer = Customer.all.sample
    restaurant = Restaurant.all.sample

    add_dishes_to_order(restaurant.dishes, customer.id, restaurant.id)

    if opinions?
        Review.create(content: write_review, rating: rand(1..5), date: recent_date, customer_id: customer.id, restaurant_id: restaurant.id)
    end
end



