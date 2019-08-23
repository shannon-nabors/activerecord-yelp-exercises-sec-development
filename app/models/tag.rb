class Tag < ActiveRecord::Base
    has_many :dish_tags
    has_many :dishes, through: :dish_tags
    validates :name, length: { minimum: 3, too_short: "too short" }
    validate :two_words_max

    private
    
    def two_words_max
        if self.name && self.name.split.length > 2
            errors.add(:too_long, "Tag must be one or two words")
        end
    end

end