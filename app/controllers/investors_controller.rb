
class InvestorsController < ApplicationController

  # def index
  #   @investor = current_investor
  #   if current_investor
  #     redirect_to '/portfolios'
  #   else
  #     redirect_to '/sessions/new'
  #   end
  # end

  def new
    @investor = Investor.new
  end

  def create
    @investor = Investor.create(investor_params)
    if @investor.id != nil
      session[:investor_id] = @investor.id
      redirect_to portfolios_path
    else
      render 'new'
    end
  end

  private

  def investor_params
    params.require(:investor).permit(:username, :password, :password_confirmation)
  end

end
