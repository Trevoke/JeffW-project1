
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
    redirect_to '/portfolios'
  end

  def portfolio_params
    params.require(:portfolio).permit(:name)
  end



end
