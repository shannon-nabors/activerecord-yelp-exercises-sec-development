class Dish < ActiveRecord::Base

    ############################## Relationships #################################

    belongs_to :restaurant
    has_many :dish_tags
    has_many :tags, through: :dish_tags
    has_many :order_dishes
    has_many :orders, through: :order_dishes

    ############################## Validations ###################################

    validates :name, presence: true
    validates :restaurant_id, presence: true
    validate :no_duplicate_tags

    ################################# Scopes #####################################

    scope :vegetarian, -> { joins(:tags).where("tags.name = 'Vegetarian'") }
    scope :untagged, -> { eager_load(:tags).where("tags.id IS NULL") }

    ########################### Instance Methods #################################

    def vegetarian?
        !!Dish.vegetarian.find_by_id(self.id)
    end

    def tag_count
        Tag.joins(:dishes).where("dishes.id = ?", self.id).count(:name)
    end

    def tag_names
        Tag.joins(:dishes).where("dishes.id = ?", self.id).pluck(:name)
    end

    ############################# Class Methods ##################################

    def self.names
        pluck(:name)
    end

    def self.max_tags
        ordered = self.joins(:tags).group("dish_id").order(Arel.sql("count(dish_id)"))
        max = ordered.last.tags.length
        most = self.joins(:tags).group("dish_id").having("count(dish_id) = ?", max).to_a
        most.length == 1 ? most[0] : most
    end

    def self.average_tag_count
        #Ideally find a different way to do this...
        sql = %{
            SELECT avg(tag_count) from (
                SELECT count(tags.id) as tag_count FROM dishes
                LEFT OUTER JOIN dish_tags ON dish_tags.dish_id = dishes.id
                LEFT OUTER JOIN tags ON tags.id = dish_tags.tag_id
                GROUP by dishes.id
            )
        }
        avg_count = ActiveRecord::Base.connection.execute(sql)
        avg_count[0]["avg(tag_count)"].round(2)
    end

    ############################# Private Methods ################################
    
    private

    def no_duplicate_tags
        #should this be in dish_tag instead of here?
        if self.tags != self.tags.uniq
            errors.add(:tags, "A dish can't have two of the same tag")
        end
    end
    
end