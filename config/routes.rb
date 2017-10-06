Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :authors, only: [:index, :show]
  resources :items, only: [:index, :show]
  resources :ledgers, only: [:index, :show]
  resources :loans, only: [:index, :show]
  resources :patrons, only: [:index, :show]
  resources :subjects, only: [:index, :show]
end
