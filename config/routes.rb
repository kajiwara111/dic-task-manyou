Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resources :users
  resources :sessions, only: %i[new create destroy]
end
