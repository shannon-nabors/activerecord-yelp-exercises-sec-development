class Order < ActiveRecord::Base

    ############################## Relationships #################################

    belongs_to :customer
    belongs_to :restaurant
    has_many :order_dishes
    has_many :dishes, through: :order_dishes
    
end