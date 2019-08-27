class Tag < ActiveRecord::Base

    ############################## Relationships #################################

    has_many :dish_tags
    has_many :dishes, through: :dish_tags

    ############################## Validations ###################################

    validates :name, length: { minimum: 3, too_short: "too short" }
    validate :two_words_max

    ################################# Scopes #####################################

    scope :unused, -> { eager_load(:dishes).where("dishes.id IS NULL") }

    ############################# Class Methods ##################################

    def self.most_common
        joins(:dishes).group("tag_id").order(Arel.sql("count(dish_id) DESC LIMIT 1"))[0]
    end

    def self.least_common
        joins(:dishes).group("tag_id").order(Arel.sql("count(dish_id) ASC LIMIT 1"))[0]
    end

    def self.uncommon
        joins(:dishes).group("tag_id").having("count(dish_id) < ?", 5)
    end

    def self.popular
        joins(:dishes).group("tag_id").order(Arel.sql("count(dish_id) DESC LIMIT 5"))
    end

    ############################# Private Methods ################################

    private
    
    def two_words_max
        if self.name && self.name.split.length > 2
            errors.add(:too_long, "Tag must be one or two words")
        end
    end

end