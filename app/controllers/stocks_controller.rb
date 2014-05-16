
class StocksController < ApplicationController
  def new
    @portfolio = Portfolio.find(params.fetch(:portfolio_id))
    @stock = Stock.new
  end

  def create
    stock_name = stock_params["name"]
    @portfolio_id = params[:portfolio_id]
    @list = Stock.find_list(stock_name)
  end

  def show
    stock = Stock.create(ticker: params.fetch(:id), name: params.fetch(:name))
    portfolio = Portfolio.find(params.fetch(:portfolio_id))
    portfolio.shares.create(num_shares: params.fetch(:num_shares), stock_id: stock.id)
    redirect_to "/portfolios/#{portfolio.id}"
  end

  private

  def stock_params
    params.require(:stock).permit(:name)
  end

end
