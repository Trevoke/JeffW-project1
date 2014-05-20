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
    portfolio = Portfolio.create(name: "testport")
    stock = Stock.create(ticker: "XOM", name: "Exxon")
    day = Day.create(trade_date: "2011-01-01", symbol: stock.ticker, close: 20.05)
    share = portfolio.shares.create(num_shares: 10, stock_id: stock.id)
    stock.days << day
    expected = {}
    expected["stock_id"] = stock.id
    expected["name"] = stock.name
    expected["ticker"] = stock.ticker
    expected["num_shares"] = share.num_shares
    expected["prices"] = {"2011-01-01" => 20.05}
    actual = Portfolio.combine_data(portfolio.id)[0]
    expect(actual).to eq(expected)
  end


  it 'can calculate summary stats once date is combined' do
    portfolio = Portfolio.create(name: "testport")
    stock = Stock.create(ticker: "XOM", name: "Exxon")
    day = Day.create(trade_date: "2011-01-01", symbol: stock.ticker, close: 20)
    stock.days << day
    day = Day.create(trade_date: "2011-01-02", symbol: stock.ticker, close: 40)
    stock.days << day
    share = portfolio.shares.create(num_shares: 10, stock_id: stock.id)
    expected = Portfolio.combine_data(portfolio.id)
    expected[0]["begin_date"] = "2011-01-01"
    expected[0]["end_date"] = "2011-01-02"
    actual = Portfolio.calculate_summary(expected)
    expected[0]["begin_price"] = 20
    expected[0]["end_price"] = 40
    expected[0]["begin_value"] = 200
    expected[0]["end_value"] = 400
    expected[0]["perc_change"] = 100
    expect(actual).to eq(expected)
  end

  it 'can aggregate summary stats across the portfolio' do
    portfolio = Portfolio.create(name: "testport")

    stock1 = Stock.create(ticker: "XOM", name: "Exxon")
    day = Day.create(trade_date: "2011-01-01", symbol: stock1.ticker, close: 20)
    stock1.days << day
    day = Day.create(trade_date: "2011-01-02", symbol: stock1.ticker, close: 40)
    stock1.days << day
    share = portfolio.shares.create(num_shares: 10, stock_id: stock1.id)

    stock2 = Stock.create(ticker: "MSFT", name: "Microsoft")
    day = Day.create(trade_date: "2011-01-01", symbol: stock2.ticker, close: 80)
    stock2.days << day
    day = Day.create(trade_date: "2011-01-02", symbol: stock2.ticker, close: 115)
    stock2.days << day
    share = portfolio.shares.create(num_shares: 20, stock_id: stock2.id)

    full_portfolio_data = Portfolio.combine_data(portfolio.id)
    full_portfolio_data.each do |stock|
      stock["begin_date"] = "2011-01-01"
      stock["end_date"] = "2011-01-02"
    end

    final = Portfolio.calculate_summary(full_portfolio_data)

    expected = {}
    expected["start_val"] = 1800
    expected["end_val"] = 2700
    expected["perc_chg"] = 50

    actual = Portfolio.aggregate(final)

    expect(actual).to eq(expected)
  end
end
