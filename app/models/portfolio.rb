class Portfolio < ActiveRecord::Base
  belongs_to :investor
  has_many :shares
  has_many :stocks, through: :shares
end
