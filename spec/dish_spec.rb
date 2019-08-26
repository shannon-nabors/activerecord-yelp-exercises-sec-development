require_relative 'spec_helper'

describe 'Dish' do

  describe "Validations:" do
    let(:alices_restaurant) {Restaurant.create(:name => "Alice's Restaurant")}

    it "has a name" do 
      dish = Dish.create(:name => "pizza", :restaurant => alices_restaurant)
      expect(dish.name).to eq("pizza")
    end
    
    it "has associated tags in an array" do
      pizza = Dish.create(:name => "pizza", :restaurant => alices_restaurant)
      
      italian = Tag.create(:name => "italian")
      pizza.tags << italian
      
      italian.reload
      expect(pizza.tags).to include(italian)
      expect(italian.dishes).to include(pizza)
    end
    
    it "validates that name is present" do 
      expect(Dish.new(:name => nil, :restaurant => alices_restaurant).valid?).to be false
      expect(Dish.new(:name => "Pizza", :restaurant => alices_restaurant).valid?).to be true
    end
    
    it "validates that restaurant is present" do 
      expect(Dish.new(:name => "Pizza", :restaurant => nil).valid?).to be false
      expect(Dish.new(:name => "Pizza", :restaurant => alices_restaurant).valid?).to be true
    end
    
    it "validates that each tag is unique" do 
      pizza = Dish.create(:name => "pizza", :restaurant => alices_restaurant)
      
      italian = Tag.create(:name => "italian")
      pizza.tags << italian
      expect(pizza.valid?).to be true
      pizza.tags << italian
      expect(pizza.valid?).to be false
    end
  end

  describe "Class methods:" do

    let(:la_malinche) { Restaurant.create(name: "La Malinche") }

    describe ".names" do
      it "returns an array of all dishes' names" do
        Dish.create(name: "Datiles", restaurant: la_malinche)
        Dish.create(name: "Patatas Bravas", restaurant: la_malinche)

        expect(Dish.names).to eq(["Datiles", "Patatas Bravas"])
      end
    end

    describe ".max_tags" do
      let(:la_malinche) { Restaurant.create(name: "La Malinche") }
      let(:vegetarian) { Tag.create(name: "Vegetarian") }
      let(:tapas) { Tag.create(name: "Tapas") }
      let(:spicy) { Tag.create(name: "Spicy") }
      let(:datiles) { Dish.create(name: "Datiles", restaurant: la_malinche) }
      let(:patatas) { Dish.create(name: "Patatas Bravas", restaurant: la_malinche) }
      let(:empanada) { Dish.create(name: "Beef Empanada", restaurant: la_malinche) }

      it "returns the dish with the most tags" do
        datiles.tags << tapas
        patatas.tags << [tapas, vegetarian]
        empanada.tags << tapas

        expect(Dish.max_tags).to eq(patatas)
      end

      it "returns an array if there's a tie" do
        datiles.tags << tapas
        patatas.tags << [tapas, vegetarian]
        empanada.tags << [tapas, spicy]

        expect(Dish.max_tags).to eq([patatas, empanada])
      end
    end

    describe ".untagged" do
      it "returns an array of any dishes with no tags" do
        la_malinche = Restaurant.create(name: "La Malinche")
        tapas = Tag.create(name: "Tapas")
        datiles = Dish.create(name: "Datiles", restaurant: la_malinche)
        patatas = Dish.create(name: "Patatas Bravas", restaurant: la_malinche)
        datiles.tags << tapas

        expect(Dish.untagged).to eq([patatas])
      end
    end

    describe ".average_tag_count" do
      it "returns the mean tag count for all dishes" do
        la_malinche = Restaurant.create(name: "La Malinche")
        vegetarian = Tag.create(name: "Vegetarian")
        tapas = Tag.create(name: "Tapas")
        spicy = Tag.create(name: "Spicy")
        datiles = Dish.create(name: "Datiles", restaurant: la_malinche)
        patatas = Dish.create(name: "Patatas Bravas", restaurant: la_malinche)
        empanada = Dish.create(name: "Beef Empanada", restaurant: la_malinche)

        datiles.tags << tapas

        expect(Dish.average_tag_count).to eq(0.33)

        patatas.tags << tapas
        patatas.tags << vegetarian

        expect(Dish.average_tag_count).to eq(1.00)
      end
    end

  end

end
