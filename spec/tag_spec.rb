require_relative 'spec_helper'

describe 'Tag' do 

  describe "Validations:" do
    let(:alices_restaurant) {Restaurant.create(:name => "Alice's Restaurant")}
    
    it "has a name" do 
      tag = Tag.create(:name => "italian")
      expect(tag.name).to eq ("italian")
    end
      
    it "has associated dishes in an array" do 
      italian = Tag.create(:name => "italian")
      
      pizza = Dish.new(:name => "pizza", :restaurant => alices_restaurant)
      pizza.tags << italian 
      pizza.save 
      
      pizza.reload
      expect(italian.dishes).to include(pizza)
      expect(pizza.tags).to include(italian)
    end
    
    it "validates that name is present" do 
      expect(Tag.new(:name => nil).valid?).to be false
      expect(Tag.new(:name => "italian").valid?).to be true 
    end
    
    it "validates that name is 3 or more characters long" do 
      expect(Tag.new(:name => "").valid?).to be false
      expect(Tag.new(:name => "a").valid?).to be false
      expect(Tag.new(:name => "ab").valid?).to be false
      expect(Tag.new(:name => "abc").valid?).to be true
      expect(Tag.new(:name => "abcd").valid?).to be true
    end
    
    it "validates that name is no more than 2 words long" do 
      expect(Tag.new(:name => "one two three").valid?).to be false 
      expect(Tag.new(:name => "one two").valid?).to be true 
      expect(Tag.new(:name => "one").valid?).to be true
    end
  end

  describe "Class methods:" do

    let(:la_malinche) { Restaurant.create(name: "La Malinche") }
    let(:vegetarian) { Tag.create(name: "Vegetarian") }
    let(:tapas) { Tag.create(name: "Tapas") }
    let(:spicy) { Tag.create(name: "Spicy") }
    let(:datiles) { Dish.create(name: "Datiles", restaurant: la_malinche) }
    let(:patatas) { Dish.create(name: "Patatas Bravas", restaurant: la_malinche) }
    let(:empanada) { Dish.create(name: "Beef Empanada", restaurant: la_malinche) }
    let(:calamari) { Dish.create(name: "Calamari", restaurant: la_malinche) }
    let(:olives) { Dish.create(name: "Olives", restaurant: la_malinche) }

    it "Tag.most_common returns the tag with the most associated dishes" do
      datiles.tags << tapas
      patatas.tags << [vegetarian, tapas]
      empanada.tags << [tapas, spicy]

      expect(Tag.most_common).to eq(tapas)
    end

    it "Tag.least_common returns the tag with the least associated dishes" do
      datiles.tags << tapas
      patatas.tags << [vegetarian, tapas, spicy]
      empanada.tags << [tapas, spicy]

      expect(Tag.least_common).to eq(vegetarian)
    end

    it "Tag.unused returns all tags that haven't been used" do
      tapas = Tag.create(name:"Tapas")
      spicy = Tag.create(name:"Spicy")
      vegetarian = Tag.create(name:"Vegetarian")

      datiles.tags << tapas

      expect(Tag.unused.length).to eq(2)

      patatas.tags << [tapas]
      empanada.tags << [tapas, spicy]
      
      expect(Tag.unused).to eq([vegetarian])
    end

    it "Tag.uncommon returns all tags that have been used fewer than five times" do
      datiles.tags << tapas
      patatas.tags << [vegetarian, tapas, spicy]
      empanada.tags << [tapas, spicy]
      calamari.tags << tapas
      olives.tags << [vegetarian, tapas]
 
      expect(Tag.uncommon.length).to eq(2)

      datiles.tags << spicy
      calamari.tags << spicy
      olives.tags << spicy

      expect(Tag.uncommon).to eq([vegetarian])
    end

    it "Tag.popular returns the top 5 tags by frequency of use" do
      seafood = Tag.create(name: "Seafood")
      shareable = Tag.create(name: "Shareable")
      lowcarb = Tag.create(name: "Low Carb")

      datiles.tags << [tapas, shareable, lowcarb]
      patatas.tags << [vegetarian, tapas, spicy, shareable]
      empanada.tags << [tapas, spicy]
      calamari.tags << [tapas, seafood, shareable]
      olives.tags << [vegetarian, tapas, shareable, lowcarb]

      expect(Tag.popular).not_to include(seafood)
      expect(Tag.popular).to include(lowcarb)
    end

  end

  describe "Instance methods:" do
    let(:la_malinche) { Restaurant.create(name: "La Malinche") }
    let(:mcgintys) { Restaurant.create(name: "McGinty's") }
    let(:vegetarian) { Tag.create(name: "Vegetarian") }
    let(:tapas) { Tag.create(name: "Tapas") }
    let(:seafood) { Tag.create(name: "Seafood") }
    let(:patatas) { Dish.create(name: "Patatas Bravas", restaurant: la_malinche) }
    let(:calamari) { Dish.create(name: "Calamari", restaurant: la_malinche) }
    let(:fish_and_chips) { Dish.create(name: "Fish and Chips", restaurant: mcgintys) }
    let(:olives) { Dish.create(name: "Olives", restaurant: la_malinche) }
    let(:fries) { Dish.create(name: "French Fries", restaurant: mcgintys) }

    it "Tag#restaurants returns any restaurants that have a dish with this tag" do
      patatas.tags << [tapas, vegetarian]
      calamari.tags << [tapas, seafood]
      fish_and_chips.tags << seafood
      
      expect(tapas.restaurants).to eq([la_malinche])
      expect(seafood.restaurants.length).to eq([2])
    end

    it "Tag#top_restaurant returns the restaurant that uses this tag the most" do
      patatas.tags << [tapas, vegetarian]
      calamari.tags << [tapas, seafood]
      olives.tags << [tapas, vegetarian]
      fish_and_chips.tags << seafood
      fries.tags << vegetarian

      expect(vegetarian.top_restaurant).to eq(la_malinche)
    end

    it "Tag#dish_count returns the number of dishes that use this tag" do
      patatas.tags << [tapas, vegetarian]
      calamari.tags << [tapas, seafood]
      olives.tags << [tapas, vegetarian]
      fish_and_chips.tags << seafood
      fries.tags << vegetarian

      expect(vegetarian.dish_count).to eq(3)
      expect(seafood.dish_count).to eq(2)
      expect(tapas.dish_count).to eq(3)
    end

  end
  
end