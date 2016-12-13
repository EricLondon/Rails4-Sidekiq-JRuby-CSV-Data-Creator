class Person < ActiveRecord::Base
  has_many :orders
  has_many :products, through: :orders
end
