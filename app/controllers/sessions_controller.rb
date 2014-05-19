
class SessionsController < ApplicationController

  def new
    # go to log-in form
  end

  def create

    investor = Investor.find_by(username: params[:username])

    if investor && investor.authenticate(params[:password])
      session[:investor_id] = investor.id
      redirect_to root_path, notice: "Signed In as #{investor.username}"
    else
      redirect_to log_in_path, alert: 'Log-In Failed'
    end

  end

  def destroy
    session[:investor_id] = nil
    redirect_to log_in_path, notice: "Logged-Out"
  end

end
