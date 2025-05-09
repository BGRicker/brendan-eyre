Rails.application.routes.draw do
  root 'static_pages#index'

  devise_for :users
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
  end

  resources :shows
  get 'press', to: 'static_pages#press'
end
