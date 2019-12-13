class Order < ActiveRecord::Base

    ############################## Relationships #################################

    belongs_to :customer
    belongs_to :restaurant
    has_many :order_dishes
    has_many :dishes, through: :order_dishes

    ############################## Validations ###################################

    validates :customer_id, presence: true
    validates :restaurant_id, presence: true
    validates :dishes, length: {minimum: 1}
    validate :dish_sources

    ############################# Private Methods ################################

    def dish_sources
        
    end

end