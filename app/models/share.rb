class Share < ActiveRecord::Base
  belongs_to :portfolio
  belongs_to :stock
  validates_uniqueness_of :stock_id, scope: :portfolio_id
end


