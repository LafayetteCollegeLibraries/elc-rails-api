class LoansController < ApplicationController
  def index
    @page = param_page
    @per_page = param_per_page
    ledger_id = params[:ledger_id]
    @ledger = Ledger.find(ledger_id) if ledger_id

    @loans = determine_loans_source.paginate(page: @page, per_page: @per_page)
  end

  def show
    @loan = Loan.find(params[:id])
  end

  private

  def determine_loans_source
    if @ledger
      @ledger.loans
    elsif params[:work_id]
      Loan.for_work(Work.find(params[:work_id]))
    elsif params[:patron_id]
      Loan.for_patron(params[:patron_id])
    else
      Loan.all
    end
  end
end
