class LoansController < ApplicationController
  def index
    ledger_id = params[:ledger_id]
    @page = param_page
    per_page = param_per_page

    if ledger_id
      @ledger = Ledger.find(ledger_id)
      @loans = @ledger.loans.paginate(page: @page, per_page: @per_page)
    else
      @loans = Loan.paginate(page: @page, per_page: @per_page)
    end
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
