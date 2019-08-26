class Restaurant < ActiveRecord::Base
    has_many :dishes
    validates :name, presence: true

    scope :mcdonalds, -> { find_by(name: "McDonald's") }
    scope :tenth, -> { limit(1).offset(9)[0] }
    scope :with_long_names, -> { where("LENGTH(name) > 12") }
    scope :focused, -> { joins(:dishes).group("restaurant_id").having("count(restaurant_id) < 5") }
    scope :large_menu, -> { joins(:dishes).group("restaurant_id").having("count(restaurant_id) > 20") }

    def self.name_like(n)
        where('name LIKE ?', "%#{n}%")
    end

    def self.name_not_like(n)
        where('name NOT LIKE ?', "%#{n}%")
    end

    def self.max_dishes
        ordered = self.joins(:dishes).group("restaurant_id").order(Arel.sql("count(restaurant_id)"))
        max = ordered.last.dishes.length
        most = self.joins(:dishes).group("restaurant_id").having("count(restaurant_id) = ?", max).to_a
        most.length == 1 ? most[0] : most
    end

    def self.vegetarian
        #having trouble figuring out how to do this with activerecord
        #methods, will return to this
        all.select do |r|
            r.dishes.all? { |dish| dish.vegetarian? }
        end
    end

end