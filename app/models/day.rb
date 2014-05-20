class Day < ActiveRecord::Base
  belongs_to :stock
  validates_uniqueness_of :trade_date, scope: :symbol

  def self.get_prices(symbol)
    days = Day.where(symbol: symbol).to_a
    price_hash = {}
    days.each do |day|
      price_hash[day.trade_date] = day.close
    end
    return price_hash
  end

  def self.verify_begin_date(begin_date, ticker)
    sorted_dates = Hash[Day.get_prices(ticker).sort].keys
    if sorted_dates.include?(begin_date)
      return begin_date
    elsif begin_date < sorted_dates.first
      return sorted_dates.first
    else
      while !sorted_dates.include?(begin_date)
        begin_date_as_date = Date.parse(begin_date)
        begin_date = (begin_date_as_date-1).to_s
      end
    end
    return begin_date
  end

  def self.verify_end_date(end_date, ticker)
    sorted_dates = Hash[Day.get_prices(ticker).sort].keys
    if sorted_dates.include?(end_date)
      return end_date
    elsif end_date > sorted_dates.last
      return sorted_dates.last
    else
      while !sorted_dates.include?(end_date)
        end_date_as_date = Date.parse(end_date)
        end_date = (end_date_as_date + 1).to_s
      end
    end
    return end_date
  end

end
