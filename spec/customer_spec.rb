require_relative 'spec_helper'

describe 'Customer' do

    describe "Validations:" do
        it "must have a name" do
            expect(Customer.new(name: nil).valid?).to be false
            expect(Customer.new(name: "Shirley Temple").valid?).to be true
        end

        it "latitude must be valid" do
            expect(Customer.new(name: "Shirley Temple", lat: -300).valid?).to be false
            expect(Customer.new(name: "Shirley Temple", lat: 91).valid?).to be false
            expect(Customer.new(name: "Shirley Temple", lat: 0).valid?).to be true
        end

        it "longitude must be valid" do
            expect(Customer.new(name: "Shirley Temple", lon: -300).valid?).to be false
            expect(Customer.new(name: "Shirley Temple", lon: 91.4446).valid?).to be true
            expect(Customer.new(name: "Shirley Temple", lon: 201).valid?).to be false
        end

    end

end