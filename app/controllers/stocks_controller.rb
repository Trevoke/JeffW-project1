
class StocksController < ApplicationController
  def new
    @portfolio = Portfolio.find(params.fetch(:portfolio_id))
    @stock = Stock.new
  end

  def index
    @portfolio_id = params.fetch(:portfolio_id)
  end

  def create
    stock_name = stock_params["name"]
    @portfolio_id = params[:portfolio_id]
    @list = Stock.find_list(stock_name)
  end

  def show
    stock = Stock.create(ticker: params.fetch(:id), name: params.fetch(:name))
    if stock.id == nil
      stock = Stock.find_by(ticker: params.fetch(:id))
    end
    stock.update_stock(stock.ticker)
    portfolio = Portfolio.find(params.fetch(:portfolio_id))
    curr_share = portfolio.shares.create(num_shares: params.fetch(:num_shares), stock_id: stock.id)
    if curr_share.id == nil
      @portfolio_id =  portfolio.id
      redirect_to "/portfolios/#{@portfolio_id}/stocks"
    else
      redirect_to "/portfolios/#{portfolio.id}"
    end
  end

  def display
    price_hash = Day.get_prices(params[:sym])
    @sorted_price_array = Hash[price_hash.sort].values
    @url = Gchart.line(:data => @sorted_price_array)
  end

  def edit
    portfolio = Portfolio.find(params.fetch(:portfolio_id))
    stock = Stock.find(params.fetch(:id))
    @share = Share.where(portfolio_id: portfolio.id, stock_id: stock.id).take
  end

  def update
    p=params
    share = Share.find(params.fetch(:share_id))
    share.num_shares = params.fetch(:num_shares)
    share.save
    redirect_to "/portfolios/#{params.fetch(:portfolio_id)}"
  end

  def destroy
    stock_id = params[:id]
    portfolio_id = params[:portfolio_id]
    share = Share.where(portfolio_id: portfolio_id, stock_id: stock_id).take
    Share.delete(share.id)
    redirect_to "/portfolios/#{portfolio_id}"
  end


  private

  def stock_params
    params.require(:stock).permit(:name)
  end

end
