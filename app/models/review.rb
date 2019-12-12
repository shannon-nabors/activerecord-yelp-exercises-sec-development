class Review < ActiveRecord::Base

    ############################## Relationships #################################

    belongs_to :customer
    belongs_to :restaurant
    
end