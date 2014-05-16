class Day < ActiveRecord::Base
  belongs_to :stock

  def self.get_prices(symbol)
    days = Day.where(symbol: symbol).to_a
    price_hash = {}
    days.each do |day|
      price_hash[day.trade_date] = day.close
    end
    return price_hash
  end
end
