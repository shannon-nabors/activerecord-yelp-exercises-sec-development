class Dish < ActiveRecord::Base
    belongs_to :restaurant
    has_many :dish_tags
    has_many :tags, through: :dish_tags
    validates :name, presence: true
    validates :restaurant_id, presence: true
    validate :no_duplicate_tags

    def no_duplicate_tags
        if self.tags != self.tags.uniq
            errors.add(:tags, "A dish can't have two of the same tag")
        end
    end
    
end