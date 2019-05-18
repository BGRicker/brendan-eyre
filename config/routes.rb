Rails.application.routes.draw do
  resources :shows
  devise_for :users
  root 'static_pages#index'
end
