class StocksController < ApplicationController
  def new
    @portfolio = Portfolio.find(params.fetch(:portfolio_id))
    authorize(@portfolio.investor_id)
    @stock = Stock.new
  end

  def create
    stock_name = stock_params["name"]
    @portfolio_id = params[:portfolio_id]
    @list = Stock.find_list(stock_name)
    if @list.empty?
      redirect_to new_portfolio_stock_path(@portfolio_id), alert: 'Stock name cannot be blank.'
    end
  end

  def show
    if params.fetch(:num_shares) == ""
      redirect_to portfolio_path(params.fetch(:portfolio_id)), alert: 'Please enter a number of shares' and return
    end
    stock = Stock.create(ticker: params.fetch(:id), name: params.fetch(:name))
    if stock.id == nil
      stock = Stock.find_by(ticker: params.fetch(:id))
    end
    stock.update_stock(stock.ticker)
    portfolio = Portfolio.find(params.fetch(:portfolio_id))
    curr_share = portfolio.shares.create(num_shares: params.fetch(:num_shares), stock_id: stock.id)
    if curr_share.id == nil
      redirect_to portfolio_path(portfolio.id), alert: 'Stock already in your portfolio.  Please use Edit to change number of shares.' and return
    end
    redirect_to portfolio_path(portfolio.id)
  end

  def display
    @portfolio = Portfolio.find(params.fetch(:portfolio_id))
    authorize(@portfolio.investor_id)
    @symbol = params.fetch(:sym)
    @b_date = Day.verify_begin_date(params.fetch(:chart_begin_date), @symbol)
    @e_date = Day.verify_end_date(params.fetch(:chart_end_date), @symbol)
    if @b_date > @e_date
      redirect_to portfolio_path(@portfolio.id), alert: 'End Date should be after Begin Date'
    else
      price_hash = Day.get_prices(params[:sym]).sort
      @prices_for_range = price_hash.select do |k,v|
        k >= params.fetch(:chart_begin_date) && k<= params.fetch(:chart_end_date)
      end
      @px_arrays = Day.split_hash(@prices_for_range)
      sorted_price_array = Hash[@prices_for_range.sort].values
      @graph_svg = Stock.graph_it(sorted_price_array)
    end
  end

  def edit
    portfolio = Portfolio.find(params.fetch(:portfolio_id))
    authorize(portfolio.investor_id)
    stock = Stock.find(params.fetch(:id))
    @share = Share.where(portfolio_id: portfolio.id, stock_id: stock.id).take
  end

  def update
    if params.fetch(:num_shares) == ""
      redirect_to portfolio_path(params.fetch(:portfolio_id)), alert: 'Please enter a number of shares'
    else
      share = Share.find(params.fetch(:share_id))
      share.num_shares = params.fetch(:num_shares)
      share.save
      redirect_to portfolio_path(params.fetch(:portfolio_id))
    end
  end

  def destroy
    stock_id = params[:id]
    portfolio_id = params[:portfolio_id]
    share = Share.where(portfolio_id: portfolio_id, stock_id: stock_id).take
    Share.delete(share.id)
    redirect_to portfolio_path(portfolio_id)
  end


  private

  def stock_params
    params.require(:stock).permit(:name)
  end

end
