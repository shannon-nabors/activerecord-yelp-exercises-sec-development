require_relative 'spec_helper'
require 'pry'

describe 'Order' do
    let(:shirley) { Customer.create(name: "Shirley Temple") }
    let(:mcdonalds) { Restaurant.create(name: "McDonald's") }
    let(:astro) { Restaurant.create(name: "Astro") }
    let(:burger) { Dish.create(name: "Burger", restaurant: mcdonalds) }
    let(:donut) { Dish.create(name: "Donut", restaurant: astro) }

    describe "Validations:" do
        it "must be associated with a customer" do
            expect(Order.new(customer: nil, restaurant: mcdonalds, dishes: [burger]).valid?).to be false
            expect(Order.new(customer: shirley, restaurant: mcdonalds, dishes: [burger]).valid?).to be true
        end

        it "must be associated with a restaurant" do
            expect(Order.new(customer: shirley, restaurant: nil, dishes: [burger]).valid?).to be false
            expect(Order.new(customer: shirley, restaurant: mcdonalds, dishes: [burger]).valid?).to be true
        end

        it "must have at least one dish" do
            order1 = Order.new(customer: shirley, restaurant: mcdonalds)
            expect(order1.save).to be false
            order2 =Order.new(customer: shirley, restaurant: mcdonalds)
            order2.dishes << burger
            expect(order2.save).to be true
        end

        it "all dishes on an order must be from the same restaurant" do
            order1 = Order.new(customer: shirley, restaurant: mcdonalds)
            order1.dishes << burger
            expect(order1.save).to be true

            order2 =Order.new(customer: shirley, restaurant: mcdonalds)
            order2.dishes << burger
            order2.dishes << donut
            expect(order2.save).to be false
        end

    end

end