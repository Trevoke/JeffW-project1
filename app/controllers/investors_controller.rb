
class InvestorsController < ApplicationController



  def index
    @investor = current_investor
    if current_investor
      redirect_to '/portfolios'
    else
      redirect_to '/sessions/new'
    end
  end

  def new
    @investor = Investor.new
  end

  def create
    new_investor = Investor.create(investor_params)
    if new_investor.id != nil
      session[:investor_id] = new_investor.id
      redirect_to portfolios_path
    else
      redirect_to investors_new_path
    end
  end

  private

  def investor_params
    params.require(:investor).permit(:username, :password, :password_confirmation)
  end

end
