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


    h_size = px_hash.size

    s1 = (h_size / 4).round(0)
    s2 = s1 * 2
    s3 = s1 * 3
    s4 = h_size

    d1 = px_hash[s1-1][0]
    d2 = px_hash[s2-1][0]
    d3 = px_hash[s3-1][0]
    d4 = px_hash[s4-1][0]

    price_array = []
    price_array[0] = {}
    price_array[1] = {}
    price_array[2] = {}
    price_array[3] = {}

    price_array[0] = px_hash.select do |k,v|
      k<= d1
    end

    price_array[1] = px_hash.select do |k,v|
      k > d1 && k<= d2
    end

    price_array[2] = px_hash.select do |k,v|
      k > d2 && k<= d3
    end

    price_array[3] = px_hash.select do |k,v|
      k > d3 && k<= d4
    end

    return price_array

  end

end
