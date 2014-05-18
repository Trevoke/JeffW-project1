class Stock < ActiveRecord::Base
  has_many :days
  has_many :shares
  has_many :portfolios, through: :shares
  validates_uniqueness_of :ticker
  # validates :ticker, :uniqueness: {scope: investor_id}, presence: true


  def self.find_list(stock_name)
    company = stock_name.gsub(" ", "+")
    url = "http://autoc.finance.yahoo.com/autoc?query=#{company}&callback=YAHOO.Finance.SymbolSuggest.ssCallback"
    raw_response = HTTParty.get(url)
    json = raw_response.match /(\{.*\})/
    result = JSON.parse(json.to_s)
    filtered = result["ResultSet"]["Result"].select do |stock|
        stock["exchDisp"]=="NYSE" || stock["exchDisp"]=="NASDAQ"
    end
  end

  def update_stock(ticker)
    curr_stock = Stock.find_by ticker: ticker
    end_day = Time.now
    if curr_stock.last_update == nil
      begin_day = Time.new(2012, 1, 1)
    elsif curr_stock.last_update == end_day.to_date.to_s
      return 0
    else
      begin_day = Date.parse(curr_stock.last_update)+1
    end
    data = YahooFinance.historical_quotes("#{ticker}", begin_day, end_day,{ raw: false, period: :daily })
    curr_stock.last_update = end_day.to_date.to_s
    curr_stock.save
    data.each do |day|
      curr_day = Day.create(trade_date: day.trade_date, symbol: day.symbol, close: day.close)
      curr_stock.days << curr_day
    end
  end

end
