class Investor < ActiveRecord::Base
  has_many :portfolios
  has_many :stocks, through: :portfolios
  has_many :shares, through: :portfolios
end
