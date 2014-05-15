class Investor < ActiveRecord::Base
  has_many :portfolios
end
