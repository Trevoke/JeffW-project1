Rails.application.routes.draw do

  root 'welcome#index'

  get '/portfolios/analyze/:id' => 'portfolios#analyze'

  resources :portfolios do
    resources :stocks, except: [:index]
  end




  # get '/portfolios' => 'portfolios#index'
  # get '/portfolios/new' => 'portfolios#new'
  # post '/portfolios' => 'portfolios#create'
  # get '/portfolios/:id' => 'portfolios#show'

  # get '/portfolios/:portfolio_id/stocks/new' => 'stocks#new'

  # post '/portfolios/:portfolio_id/stocks' => 'stocks#list'

end
