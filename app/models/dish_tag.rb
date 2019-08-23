class DishTag < ActiveRecord::Base
    belongs_to :tag 
    belongs_to :dish
    # validates :dish, uniqueness: { scope: :tag }
end