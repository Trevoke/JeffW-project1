class PortfoliosController < ApplicationController

  def index
  end

  def new
    @portfolio = Portfolio.new
    authorize(current_investor.id)
  end

  def create
    new_portfolio = Portfolio.create(portfolio_params)
    if new_portfolio.id == nil
      redirect_to new_portfolio_path, alert: 'Name cannot be blank'
    else
      current_investor.portfolios << new_portfolio
      redirect_to portfolio_path(new_portfolio.id)
    end
  end

  def show
    @portfolio = Portfolio.find(params.fetch(:id))
    @details = Portfolio.populate_portfolio(params.fetch(:id))
    authorize(@portfolio.investor_id)
  end

  def analyze
    @portfolio = Portfolio.find(params.fetch(:id))
    authorize(@portfolio.investor_id)
    @begin_date = params.fetch(:begin_date)
    @end_date = params.fetch(:end_date)
    if @begin_date > @end_date
      redirect_to portfolio_path(@portfolio.id), alert: 'End Date should be after Begin Date'
    end
    # Here there is a lot of logic which looks like it should be wrapped in a method
    # inside an object for easy testing / maintenance
    # Having it here in the controller means the only way to test it is to
    # call this action.
    full_portfolio_data = Portfolio.combine_data(@portfolio.id)
    full_portfolio_data.each do |stock|
      stock["begin_date"] = Day.verify_begin_date(params.fetch(:begin_date), stock["ticker"])
      stock["end_date"] = Day.verify_end_date(params.fetch(:end_date), stock["ticker"])
    end
    @final = Portfolio.calculate_summary(full_portfolio_data)
    @portfolio_aggregate = Portfolio.aggregate(@final)
  end

  def edit
    @portfolio = Portfolio.find(params.fetch(:id))
    authorize(@portfolio.investor_id)
  end

  def update
    portfolio = Portfolio.find(params.fetch(:id))
    new_name = portfolio_params["name"]
    if new_name == ""
      redirect_to edit_portfolio_path(portfolio.id), alert: 'Name cannot be blank'
    else
      portfolio.name = new_name
      portfolio.save
      redirect_to portfolio_path(portfolio.id)
    end
  end

  def destroy
    id = params[:id]
    Portfolio.delete(id)
    redirect_to portfolios_path
  end


  private

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end


end
