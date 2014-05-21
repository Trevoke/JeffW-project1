
class SessionsController < ApplicationController

  def new
    if current_investor
      redirect_to portfolios_path
    end
  end

  def create
    investor = Investor.find_by(username: params[:username])
    if investor && investor.authenticate(params[:password])
      session[:investor_id] = investor.id
      redirect_to root_path
    elsif !investor
      redirect_to log_in_path, alert: 'Invalid Username'
    else
      redirect_to log_in_path, alert: 'Incorrect Password'
    end
  end

  def destroy
    session[:investor_id] = nil
    redirect_to log_in_path
  end

end
