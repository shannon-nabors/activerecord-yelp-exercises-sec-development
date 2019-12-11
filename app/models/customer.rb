class Customer < ActiveRecord::Base

    ############################## Relationships #################################

    has_many :orders
    has_many :reviews
    
end