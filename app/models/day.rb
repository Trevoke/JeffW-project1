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

  def self.split_hash(px_hash)
    day_count = px_hash.size
    row_count = (day_count/4).to_i
    remainder = day_count % 4
    previous = 0
    rows_per_col = []
    for index in 0..3
      add_on = 0
      if remainder > 0
        add_on = 1
      end
      rows_per_col[index] = previous + row_count+add_on
      remainder -= 1
      previous = rows_per_col[index]
    end
    begin_date = "2011-12-31"
    end_date = px_hash[rows_per_col[0]-1][0]
    price_array = []
    for index in 0..3
      price_array[index] = px_hash.select do |k,v|
        k >= begin_date && k<= end_date
      end
      if index < 3
        begin_date = px_hash[rows_per_col[index]][0]
        end_date = px_hash[rows_per_col[index+1]-1][0]
      end
    end
    return price_array
  end

end
