class LoansController < ApplicationController
  def index
    @loans = Loan.paginate(page: params[:page], per_page: params[:per_page])
  end

  # TODO: how can we map this in routes?
  #
  # ```
  # # config/routes.rb
  # resources :loans do
  #   get 'random', use 'loans#random'
  # end
  # ```
  #
  # that will pass the randomly pulled ID to 'loans#show'? something like:
  #
  # ```
  # # app/controllers/loans_controller.rb
  # # ...
  # def random
  #   @loan = Loan.random
  #   redirect_to @loan
  # end
  # ```
  def show
    id = params[:id]

    if (id == 'random')
      redirect_to Loan.random
    else
      @loan = Loan.find(id)
    end
  end
end
