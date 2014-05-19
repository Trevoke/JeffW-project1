class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_investor

  def current_investor
    Investor.find(session[:investor_id]) if session[:investor_id]
  end

end


#                root GET    /                                                   investors#index
#            investors GET    /investors(.:format)                                investors#index
#        investors_new GET    /investors/new(.:format)                            investors#new
#                      POST   /investors(.:format)                                investors#create
#                      GET    /portfolios/analyze/:id(.:format)                   portfolios#analyze
#                      GET    /stocks/:sym(.:format)                              stocks#display
#     portfolio_stocks GET    /portfolios/:portfolio_id/stocks(.:format)          stocks#index
#                      POST   /portfolios/:portfolio_id/stocks(.:format)          stocks#create
#  new_portfolio_stock GET    /portfolios/:portfolio_id/stocks/new(.:format)      stocks#new
# edit_portfolio_stock GET    /portfolios/:portfolio_id/stocks/:id/edit(.:format) stocks#edit
#      portfolio_stock GET    /portfolios/:portfolio_id/stocks/:id(.:format)      stocks#show
#                      PATCH  /portfolios/:portfolio_id/stocks/:id(.:format)      stocks#update
#                      PUT    /portfolios/:portfolio_id/stocks/:id(.:format)      stocks#update
#                      DELETE /portfolios/:portfolio_id/stocks/:id(.:format)      stocks#destroy
#           portfolios GET    /portfolios(.:format)                               portfolios#index
#                      POST   /portfolios(.:format)                               portfolios#create
#        new_portfolio GET    /portfolios/new(.:format)                           portfolios#new
#       edit_portfolio GET    /portfolios/:id/edit(.:format)                      portfolios#edit
#            portfolio GET    /portfolios/:id(.:format)                           portfolios#show
#                      PATCH  /portfolios/:id(.:format)                           portfolios#update
#                      PUT    /portfolios/:id(.:format)                           portfolios#update
#                      DELETE /portfolios/:id(.:format)                           portfolios#destroy
#               log_in GET    /sessions/new(.:format)                             sessions#new
#             sessions POST   /sessions(.:format)                                 sessions#create
#              log_out DELETE /sessions(.:format)                                 sessions#destroy
