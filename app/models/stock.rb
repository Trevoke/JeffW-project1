class Stock < ActiveRecord::Base
  has_many :days
  has_many :shares
  has_many :portfolios, through: :shares


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

end
