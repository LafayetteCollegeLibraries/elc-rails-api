class LoansController < ApplicationController
  def index
    ledger_id = params[:ledger_id]
    patron_id = params[:patron_id]
    work_id = params[:work_id]
    @page = param_page
    @per_page = param_per_page

    @loans = if ledger_id
               @ledger = Ledger.find(ledger_id)
               @ledger.loans
             elsif work_id
               Loan.for_work(Work.find(work_id)).paginate(page: @page, per_page: @per_page)
             elsif patron_id
               Loan.for_patron(patron_id)
             else
               Loan
             end.paginate(page: @page, per_page: @per_page)
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
