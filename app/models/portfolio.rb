class Portfolio < ActiveRecord::Base
  belongs_to :investor
  has_many :shares
  has_many :stocks, through: :shares
  validates :name, presence: true

  def self.populate_portfolio(portfolio_id)
    portfolio = Portfolio.find(portfolio_id)
    portfolio_details = []
    portfolio.stocks.each do |stock|
      stock_hash = {}
      stock_hash["ticker"] = stock.ticker
      stock_hash["name"] = stock.name
      curr_share = Share.where(portfolio_id: portfolio_id, stock_id: stock.id).take
      stock_hash["num_shares"] = curr_share.num_shares
      stock_hash["id"] = stock.id
      stock.update_stock(stock.ticker)
      portfolio_details << stock_hash
    end
    return portfolio_details
  end

  def self.combine_data(portfolio_id)
    portfolio = Portfolio.find(portfolio_id)
    combined = []
    portfolio.stocks.each do |stock|
      curr_stock = {}
      curr_stock["stock_id"] = stock.id
      curr_stock["name"] = stock.name
      curr_stock["ticker"] = stock.ticker
      curr_stock["num_shares"] = Share.where(stock_id: stock.id, portfolio_id: portfolio_id).take.num_shares
      curr_stock["prices"] = Day.get_prices(stock.ticker)
      combined << curr_stock
    end
    return combined
  end

  def self.calculate_summary(full_portfolio_data)
    full_portfolio_data.each do |stock|
      stock["begin_price"] = stock["prices"][stock["begin_date"]]
      stock["end_price"] = stock["prices"][stock["end_date"]]
      stock["begin_value"]= (stock["begin_price"] * stock["num_shares"])
      stock["end_value"]=(stock["end_price"] * stock["num_shares"])
      stock["perc_change"]= (stock["end_value"]/stock["begin_value"]-1) * 100
    end
    return full_portfolio_data
  end

  # final what?
  def self.aggregate(final)
    start_val = 0
    end_val = 0
    final.each do |stock|
      start_val += stock["begin_value"]
      end_val += stock["end_value"]
    end

    aggregate = {}
    aggregate["start_val"] = start_val
    aggregate["end_val"] = end_val
    aggregate["perc_chg"] = (end_val/start_val - 1) * 100

    return aggregate
  end

end
