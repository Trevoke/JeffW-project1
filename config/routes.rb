Rails.application.routes.draw do

  root 'welcome#index'
  get '/portfolios' => 'portfolios#index'
  get '/portfolios/new' => 'portfolios#new'
  post '/portfolios' => 'portfolios#create'
end
