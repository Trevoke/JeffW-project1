class Stock < ActiveRecord::Base
  has_many :days
  has_many :shares
  has_many :portfolios, through: :shares
end
