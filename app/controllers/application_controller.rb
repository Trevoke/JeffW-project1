class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

# temp way of obtaining user.  only for one user.  needs to be fixed.
  def current_investor
    @current_investor = Investor.first
  end

  # def populate_days
  #   stocks = Stock.all
  #   stocks.each do |stock|
  #     stock.update_stock(stock.ticker)
  #   end
  # end

end
