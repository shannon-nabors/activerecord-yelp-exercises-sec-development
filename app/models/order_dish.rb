class Order < ActiveRecord::Base
    belongs_to :order
    belongs_to :dish 
end