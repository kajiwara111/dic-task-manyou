Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks
  resources :users
  resources :sessions, only: %i[new create destroy]
end
