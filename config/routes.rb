Rails.application.routes.draw do

  root 'sessions#new'

  get '/investors/new' => 'investors#new'
  post '/investors' => 'investors#create'

  get '/portfolios/:portfolio_id/stocks/exists' => 'stocks#exists'
  get '/portfolios/analyze/:id' => 'portfolios#analyze'
  get '/stocks/:sym' => 'stocks#display'
  resources :portfolios do
    resources :stocks, except: [:index]
  end


  get '/sessions/new' => 'sessions#new', as: 'log_in'
  post '/sessions' => 'sessions#create'
  delete '/sessions' => 'sessions#destroy', as: 'log_out'



  # get '/portfolios' => 'portfolios#index'
  # get '/portfolios/new' => 'portfolios#new'
  # post '/portfolios' => 'portfolios#create'
  # get '/portfolios/:id' => 'portfolios#show'

  # get '/portfolios/:portfolio_id/stocks/new' => 'stocks#new'

  # post '/portfolios/:portfolio_id/stocks' => 'stocks#list'

end
