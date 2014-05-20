
class PortfoliosController < ApplicationController



  def index
  end

  def new
    @portfolio = Portfolio.new
    authorize(current_investor.id)
  end

  def create
    new_portfolio = Portfolio.create(portfolio_params)
    current_investor.portfolios << new_portfolio
    redirect_to portfolio_path(new_portfolio.id)
  end

  def show
    @portfolio = Portfolio.find(params[:id])
    @details = Portfolio.populate_portfolio(params[:id])
    authorize(@portfolio.investor_id)
  end

  def analyze
    portfolio = Portfolio.find(params.fetch(:id))
    authorize(portfolio.investor_id)
    @begin_date = params.fetch(:begin_date)
    @end_date = params.fetch(:end_date)
    full_portfolio_data = Portfolio.combine_data(portfolio.id)
    full_portfolio_data.each do |stock|
      #maybe something here that says end_date has te be after begin_date?
      stock["begin_date"] = Day.verify_begin_date(params.fetch(:begin_date), stock["ticker"])
      stock["end_date"] = Day.verify_end_date(params.fetch(:end_date), stock["ticker"])
    end

    @final = Portfolio.calculate_summary(full_portfolio_data)

    @portfolio_aggregate = Portfolio.aggregate(@final)

    # @start_val = 0
    # @end_val = 0

    # @full_portfolio_data.each do |stock|
    #   @begin_date = Day.verify_begin_date(params.fetch(:begin_date), stock["ticker"])
    #   @end_date = Day.verify_end_date(params.fetch(:end_date), stock["ticker"])
    #   stock["begin_price"] = stock["prices"][@begin_date]
    #   stock["end_price"] = stock["prices"][@end_date]
    #   stock["begin_value"]= (stock["begin_price"] * stock["num_shares"]).round(3)
    #   stock["end_value"]=(stock["end_price"] * stock["num_shares"]).round(3)
    #   stock["perc_change"]= (stock["end_value"]/stock["begin_value"]-1).round(4)*100
    #   @start_val += stock["begin_value"]
    #   @end_val += stock["end_value"]
    # end

    #@perc_chg = (@end_val/@start_val-1).round(4)*100
    #@perc_chg = 0
  end

  def edit
    @portfolio = Portfolio.find(params.fetch(:id))
    authorize(@portfolio.investor_id)
  end

  def update
    portfolio = Portfolio.find(params.fetch(:id))
    new_name = portfolio_params["name"]
    portfolio.name = new_name
    portfolio.save
    redirect_to "/portfolios/#{portfolio.id}"
  end

  def destroy
    id = params[:id]
    Portfolio.delete(id)
    redirect_to "/portfolios"
  end


  private

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end


end
