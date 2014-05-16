
class PortfoliosController < ApplicationController

  before_action:current_investor

  def index
  end

  def new
    @portfolio = Portfolio.new
  end

  def create
    new_portfolio = Portfolio.create(portfolio_params)
    @current_investor.portfolios << new_portfolio
    redirect_to "/portfolios/#{new_portfolio.id}"
  end

  def show
    @portfolio = Portfolio.find(params[:id])
    @details = Portfolio.populate_portfolio(params[:id])
  end

  def analyze
    portfolio = Portfolio.find(params.fetch(:id))
    @full_portfolio_data = Portfolio.combine_data(portfolio.id)
    @full_portfolio_data.each do |stock|
      stock["begin_price"] = stock["prices"][params.fetch(:begin_date)]
      stock["end_price"] = stock["prices"][params.fetch(:end_date)]
      stock["begin_value"]= (stock["begin_price"] * stock["num_shares"]).round(3)
      stock["end_value"]=(stock["end_price"] * stock["num_shares"]).round(3)
      stock["perc_change"]= (stock["end_value"]/stock["begin_value"]-1).round(4)*100
    end
  end

  private



  def portfolio_params
    params.require(:portfolio).permit(:name)
  end

end
