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
            expect(Order.new(customer: nil, restaurant: mcdonalds).valid?).to be false
            expect(Order.new(customer: shirley, restaurant: mcdonalds).valid?).to be true
        end

        it "must be associated with a restaurant" do
            expect(Order.new(customer: shirley, restaurant: nil).valid?).to be false
            expect(Order.new(customer: shirley, restaurant: mcdonalds).valid?).to be true
        end

        it "must have at least one dish" do
            #to be continued
        end

        it "all dishes on an order must be from the same restaurant" do
            order1 = Order.new(customer: shirley, restaurant: mcdonalds)
            OrderDish.new(order: order1, dish: burger)
            expect(order1.save).to be true

            order2 =Order.new(customer: shirley, restaurant: mcdonalds)
            OrderDish.new(order: order2, dish: burger)
            OrderDish.new(order: order2, dish: donut)
            expect(order2.save).to be false
        end

    end

end