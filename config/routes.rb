Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :author, :item, :subject, only: [:index, :show]

  resources :loan, only: [:index, :show] do
    get '/random', to: 'loan#random'
  end
end
