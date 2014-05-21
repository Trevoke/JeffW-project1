
class StocksController < ApplicationController
  def new
    @portfolio = Portfolio.find(params.fetch(:portfolio_id))
    authorize(@portfolio.investor_id)
    @stock = Stock.new
  end

  def exists
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
      #not sure next line is needed.  also perhaps use notice/alert here instead
      @portfolio_id =  portfolio.id
      redirect_to "/portfolios/#{@portfolio_id}/stocks/exists"
    else
      redirect_to "/portfolios/#{portfolio.id}"
    end
  end

  def display
    @portfolio = Portfolio.find(params.fetch(:portfolio_id))
    authorize(@portfolio.investor_id)
    @symbol = params.fetch(:sym)
    @b_date = params.fetch(:chart_begin_date)
    @e_date = params.fetch(:chart_end_date)
    price_hash = Day.get_prices(params[:sym]).sort


    @prices_for_range = price_hash.select do |k,v|
      k >= params.fetch(:chart_begin_date) && k<= params.fetch(:chart_end_date)
    end

    @px_arrays = Day.split_hash(@prices_for_range)

    @sorted_price_array = Hash[@prices_for_range.sort].values

    #@url = Gchart.line(:data => @sorted_price_array)
    @x = Stock.m2(@sorted_price_array)
  end

  def edit
    portfolio = Portfolio.find(params.fetch(:portfolio_id))
    authorize(portfolio.investor_id)
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
