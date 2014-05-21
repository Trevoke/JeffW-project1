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

#                root GET    /                                                    sessions#new
#        investors_new GET    /investors/new(.:format)                            investors#new check, ok open to all
#            investors POST   /investors(.:format)                                investors#create check, ok not seen
#                      GET    /portfolios/analyze/:id(.:format)                   portfolios#analyze check, put auth in
#                      GET    /stocks/:sym(.:format)                              stocks#display check, ok open to all
#                      GET    /portfolios/:portfolio_id/stocks/exists(.:format)   stocks#exists check, self protecting
#                      POST   /portfolios/:portfolio_id/stocks(.:format)          stocks#create check, self protecting
#  new_portfolio_stock GET    /portfolios/:portfolio_id/stocks/new(.:format)      stocks#new check, ok put auth in
# edit_portfolio_stock GET    /portfolios/:portfolio_id/stocks/:id/edit(.:format) stocks#edit check, ok put auth in
#      portfolio_stock GET    /portfolios/:portfolio_id/stocks/:id(.:format)      stocks#show check, ok self protecting
#                      PATCH  /portfolios/:portfolio_id/stocks/:id(.:format)      stocks#update check, need to clean up path
#                      PUT    /portfolios/:portfolio_id/stocks/:id(.:format)      stocks#update check, need to clean up path
#                      DELETE /portfolios/:portfolio_id/stocks/:id(.:format)      stocks#destroy check, not seen
#           portfolios GET    /portfolios(.:format)                               portfolios#index check, ok will error without anyway
#                      POST   /portfolios(.:format)                               portfolios#create check, ok not seen
#        new_portfolio GET    /portfolios/new(.:format)                           portfolios#new check, ok, put auth in
#       edit_portfolio GET    /portfolios/:id/edit(.:format)                      portfolios#edit check, ok, put auth in
#            portfolio GET    /portfolios/:id(.:format)                           portfolios#show check, ok, put auth in
#                      PATCH  /portfolios/:id(.:format)                           portfolios#update check, ok not seen
#                      PUT    /portfolios/:id(.:format)                           portfolios#update check, ok not seen
#                      DELETE /portfolios/:id(.:format)                           portfolios#destroy check, ok not seen
#               log_in GET    /sessions/new(.:format)                             sessions#new  check, ok open to all
#             sessions POST   /sessions(.:format)                                 sessions#create  check, ok not seen
#              log_out DELETE /sessions(.:format)                                 sessions#destroy check, ok not seen
