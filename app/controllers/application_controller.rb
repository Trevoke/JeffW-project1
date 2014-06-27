class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_investor

  def current_investor
    Investor.find(session[:investor_id]) if session[:investor_id]
  end

  def authorize(investor_id)
    if investor_id != current_investor.id
      redirect_to root_path
    end
  end
end
