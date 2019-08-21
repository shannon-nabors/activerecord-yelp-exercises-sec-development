class Restaurant < ActiveRecord::Base
    has_many :dishes
    validates :name, presence: true

    def self.mcdonalds
        self.find_by(name: "McDonalds")
    end

    def self.tenth
        self.find(10)
    end

    def self.with_long_names
        self.where("LENGTH(name) > 12")
    end

    def self.name_like(n)
        self.where('name LIKE ?', "%#{n}%")
    end

    def self.name_not_like(n)
        self.where('name NOT LIKE ?', "%#{n}%")
    end

end