class Customer < ActiveRecord::Base

    ############################## Relationships #################################

    has_many :orders
    has_many :reviews
    
    ############################## Validations ###################################

    validates :name, presence: true
    validates :lat, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, allow_nil: true }
    validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, allow_nil: true }

end