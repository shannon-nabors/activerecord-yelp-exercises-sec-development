class Dish < ActiveRecord::Base
    belongs_to :restaurant
    has_many :dish_tags
    has_many :tags, through: :dish_tags
    validates :name, presence: true
    validates :restaurant_id, presence: true
end