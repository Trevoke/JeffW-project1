Rails.application.routes.draw do

  root 'sessions#new'

  get '/investors/new' => 'investors#new'
  post '/investors' => 'investors#create'

  get '/portfolios/analyze/:id' => 'portfolios#analyze', as: 'analyze'
  get '/stocks/:sym' => 'stocks#display', as: 'graph'
  resources :portfolios do
    resources :stocks, except: [:index]
  end


  get '/sessions/new' => 'sessions#new', as: 'log_in'
  post '/sessions' => 'sessions#create'
  delete '/sessions' => 'sessions#destroy', as: 'log_out'

end
