
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
    Investor.create(investor_params)
    redirect_to root_path
  end


  private

  def investor_params
    params.require(:investor).permit(:username, :password, :password_confirmation)
  end

end
