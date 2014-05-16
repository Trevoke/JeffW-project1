class Portfolio < ActiveRecord::Base
  belongs_to :investor
  has_many :shares
  has_many :stocks, through: :shares

  def self.populate_portfolio(portfolio_id)
    portfolio = Portfolio.find(portfolio_id)
    portfolio_details = []
    portfolio.stocks.each do |stock|
      stock_hash = {}
      stock_hash["ticker"] = stock.ticker
      stock_hash["name"] = stock.name
      curr_share = Share.where(portfolio_id: portfolio_id, stock_id: stock.id).take
      stock_hash["num_shares"] = curr_share.num_shares
      portfolio_details << stock_hash
    end
    return portfolio_details
  end
end
