class Tag < ActiveRecord::Base
    validates :name, length: { minimum: 3, too_short: "too short" }
    validate :two_words_max

    private
    
    def two_words_max
        if self.name.split.length > 2
            errors.add(:too_long, "Tag must be one or two words")
        end
    end

end