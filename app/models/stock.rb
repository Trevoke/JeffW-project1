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
      begin_day = Date.parse(curr_stock.last_update)
    end
    data = YahooFinance.historical_quotes("#{ticker}", begin_day, end_day,{ raw: false, period: :daily })
    curr_stock.last_update = end_day.to_date.to_s
    curr_stock.save
    data.each do |day|
      curr_day = Day.create(trade_date: day.trade_date, symbol: day.symbol, close: day.close)
      curr_stock.days << curr_day
    end
  end


  # def self.some_method
  #   vis = Rubyvis::Panel.new do
  #   width 150
  #   height 150

  #   bar do
  #     data [1, 1.2, 1.7, 1.5, 0.7, 0.3]
  #     width 20
  #     height {|d| d * 80}
  #     bottom(0)
  #     left {index * 25}
  #     end
  #   end

  #   vis.render
  #   vis.to_svg
  # end


  def self.m2(prices)
    num_prices = prices.count
    data = pv.range(1, num_prices+1, 1).map {|x|
    OpenStruct.new({:x=> x, :y=> prices[x-1]})
    }


    w = 600
    h = 300
    x = pv.Scale.linear(1,num_prices).range(0, w)

    low = prices.min
    high = prices.max


    y = pv.Scale.linear(low, high).range(0, h);

    #The root panel
    vis = pv.Panel.new() do
      width w
      height h
      bottom 20
      left 20
      right 10
      top 5

      # Y-axis and ticks
      rule do
        data y.ticks(5)
        bottom(y)
        stroke_style {|d| d!=0 ? "#eee" : "#000"}
        label(:anchor=>"left") {
          text y.tick_format
        }
      end

      # X-axis and ticks.
      rule do
        data x.ticks()
        visible {|d| d!=0}
        left(x)
        bottom(-5)
        height(5)
        #label(:anchor=>'bottom') {
        #  text(x.tick_format)
        #}
      end

      #/* The area with top line. */
      area do |a|
        a.data data
        a.bottom(1)
        a.left {|d| x.scale(d.x)}
        a.height {|d| y.scale(d.y)}
        a.fill_style("rgb(121,173,210)")
        #a.fill_style("rgb(200,200,200)")
        a.line(:anchor=>'top') {
          line_width(3)
        }
      end
    end
    vis.render();
    vis.to_svg
  end
end
