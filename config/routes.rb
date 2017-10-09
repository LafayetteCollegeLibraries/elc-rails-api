Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :authors, :items, :patrons, :subjects, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  resources :loans, only: [:index, :show]
  
  resources :ledgers, only: [:index, :show] do
    resources :loans, only: [:index, :show]
  end
end
