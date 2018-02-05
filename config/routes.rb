Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  resources :authors, :patrons, :subjects, :works, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  resources :authors, :subjects, only: [:show] do
    resources :works, only: [:index]
  end

  resources :loans, only: [:index, :show]
  
  resources :ledgers, only: [:index, :show] do
    resources :loans, only: [:index, :show]
  end

  resources :works, only: [:index, :show] do
    resources :loans, only: [:index]
  end
end
