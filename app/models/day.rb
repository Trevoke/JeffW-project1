class Day < ActiveRecord::Base
  belongs_to :stock

  def self.get_prices(symbol)
    days = Day.where(symbol: symbol).to_a
  end
end
