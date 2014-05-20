require 'spec_helper'

describe Portfolio do
  it 'can obtain list of its stocks with share count' do
    portfolio = Portfolio.create(name: "testport")
    stock = Stock.create(ticker: "XOM", name: "Exxon")
    share = portfolio.shares.create(num_shares: 10, stock_id: stock.id)
    expected_hash = {}
    expected_hash["ticker"] = "XOM"
    expected_hash["name"] = "Exxon"
    expected_hash["num_shares"] = 10
    expected_hash["id"] = stock.id
    actual_hash = Portfolio.populate_portfolio(portfolio.id)[0]
    expect(actual_hash).to eq(expected_hash)
  end

  it 'can combine data from shares and days tables' do

  end

end
