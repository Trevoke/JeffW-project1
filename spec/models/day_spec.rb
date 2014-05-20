require 'spec_helper'

describe Day do
  it 'can retrieve stock historical price info from days table' do
    stock1 = Stock.create(ticker: "XOM", name: "Exxon")
    day = Day.create(trade_date: "2011-01-01", symbol: stock1.ticker, close: 20)
    stock1.days << day
    day = Day.create(trade_date: "2011-01-02", symbol: stock1.ticker, close: 40)
    stock1.days << day
    expected = {}
    expected["2011-01-01"] = 20
    expected["2011-01-02"] = 40
    actual = Day.get_prices("XOM")
    expect(actual).to eq(expected)
  end


end
