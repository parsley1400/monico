Rails.application.routes.draw do
  get 'sessions/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#index'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'
  get '/friends/search',  to: 'friends#search'
  get '/groups/search/:id',  to: 'groups#search'
  post  '/groups/wakeup/:id',   to: 'groups#wakeup'
  get '/groups/add/:id',  to: 'groups#add'
  post '/groups/make/:id',  to: 'groups#make'
  post '/groups/time/:id',  to: 'groups#time'
  post  '/groups/sleep/:id',   to: 'groups#sleep'
  post  '/groups/reset/:id',   to: 'groups#reset'
  get  '/users/:id/delete',   to: 'users#delete'
  post  '/follower/:id/delete',   to: 'friends#follower'

  resources :users, only: [ :new, :create, :show, :edit, :update, :destroy ]
  resources :friends, only: [ :new, :create, :show ]
  resources :groups, only: [ :index, :new, :create, :show, :edit, :update ]

end
