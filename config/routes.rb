Rails.application.routes.draw do
  root 'static_pages#index'

  devise_for :users
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
  end

  resources :shows
end
