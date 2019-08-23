require_relative 'spec_helper'

describe 'Restaurant' do

  describe "Validations:" do
    it "has a name" do
      restaurant = Restaurant.create(:name => "Alice's Restaurant")
      expect(restaurant.name).to eq ("Alice's Restaurant")
    end
    
    it "has associated dishes in an array" do
      alices = Restaurant.create(:name => "Alice's Restaurant")
      
      pizza = Dish.new(:name => "pizza")
      pizza.restaurant = alices
      pizza.save
      
      pizza.reload
      expect(alices.dishes).to include(pizza)
      expect(pizza.restaurant).to eq(alices)
    end
    
    it "validates that name is present" do 
      expect(Restaurant.new(:name => nil).valid?).to be false
      expect(Restaurant.new(:name => "Alice's Restaurant").valid?).to be true
    end
  end

  describe "Class methods:" do
    describe ".mcdonalds" do
      it "finds a McDonald's" do
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")
        mcdonalds = Restaurant.create(name: "McDonald's")
        next_mcdonalds = Restaurant.create(name: "McDonald's")

        expect(Restaurant.mcdonalds).to eq(mcdonalds)
      end
    end

    describe ".tenth" do
      it "returns the tenth restaurant" do
        2.times { Restaurant.create(name: "Old McDonald's") }
        Restaurant.destroy_all
        9.times { Restaurant.create(name: "McDonald's") }
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")
        5.times { Restaurant.create(name: "McDonald's") }

        expect(Restaurant.tenth).to eq(not_mcdonalds)
      end
    end

    describe ".with_long_names" do
      it "returns an array of restaurants whose names contain more than 12 characters" do
        mcdonalds = Restaurant.create(name: "McDonald's")
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")

        expect(Restaurant.with_long_names).to include(not_mcdonalds)
        expect(Restaurant.with_long_names).not_to include(mcdonalds)
      end
    end

    describe "name_like" do
      it "finds all restaurants with a name like the string passed in" do
        mcdonalds = Restaurant.create(name: "McDonald's")
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")

        expect(Restaurant.name_like("McDo").length).to eq(2)
        expect(Restaurant.name_like("Burger King").length).to eq(0)
        expect(Restaurant.name_like("Not")).to include(not_mcdonalds)
        expect(Restaurant.name_like("Not")).not_to include(mcdonalds)
      end
    end

    describe "name_not_like" do
      it "finds all restaurants with a name unlike the string passed in" do
        mcdonalds = Restaurant.create(name: "McDonald's")
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")

        expect(Restaurant.name_not_like("McDo").length).to eq(0)
        expect(Restaurant.name_not_like("Burger King").length).to eq(2)
        expect(Restaurant.name_not_like("Not")).to include(mcdonalds)
        expect(Restaurant.name_not_like("Not")).not_to include(not_mcdonalds)
      end
    end


    describe "max_dishes" do
      it "returns the restaurant with the most dishes" do
        mcdonalds = Restaurant.create(name: "McDonald's")
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")
        2.times { Dish.create(name: "Burger", restaurant_id: 1) }
        Dish.create(name: "Sushi", restaurant_id: 2)

        expect(Restaurant.max_dishes).to eq(mcdonalds)
      end

      it "returns an array if there's a tie" do
        mcdonalds = Restaurant.create(name: "McDonald's")
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")
        2.times { Dish.create(name: "Burger", restaurant_id: 1) }
        2.times { Dish.create(name: "Sushi", restaurant_id: 2) }

        expect(Restaurant.max_dishes).to include(not_mcdonalds)
      end
    end

    describe ".focused" do
      it "returns all restaurants with fewer than 5 dishes" do
        mcdonalds = Restaurant.create(name: "McDonald's")
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")
        4.times { Dish.create(name: "Burger", restaurant_id: 1) }
        Dish.create(name: "Sushi", restaurant_id: 2)
        
        expect(Restaurant.focused).to include(mcdonalds)
        expect(Restaurant.focused).to include(not_mcdonalds)

        Dish.create(name: "Fries", restaurant_id: 1)

        expect(Restaurant.focused).not_to include(mcdonalds)
      end
    end

    describe ".large_menu" do
      it "returns all restaurants with more than 20 dishes" do
        extravagant_long_menu_mcdonalds = Restaurant.create(name: "McDonald's")
        20.times { Dish.create(name: "Burger", restaurant_id: 1) }

        expect(Restaurant.large_menu.length).to eq(0)

        Dish.create(name: "Burger", restaurant_id: 1)

        expect(Restaurant.large_menu).to include(extravagant_long_menu_mcdonalds)
      end
    end

    describe ".vegetarian" do
      it "returns all restaurants where every dish has the vegetarian tag" do
        not_mcdonalds = Restaurant.create(name: "Not McDonald's")
        2.times { Dish.create(name: "Sushi", restaurant_id: 1) }
        vegetarian = Tag.create(name: "Vegetarian")
        Dish.find(1).tags << vegetarian

        expect(Restaurant.vegetarian.length).to eq(0)

        Dish.find(2).tags << vegetarian

        expect(Restaurant.vegetarian).to include(not_mcdonalds)
      end
    end

  end
end
