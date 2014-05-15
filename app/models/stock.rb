class Stock < ActiveRecord::Base
  has_and_belongs_to_many :portfolios
  has_many :days
end
