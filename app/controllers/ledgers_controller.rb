class LedgersController < ApplicationController
  def index
    @ledgers = Ledger.all
  end

  def show
    @ledger = Ledger.find(params[:id])
    @loans = Loan.where(ledger: @ledger)
                 .paginate(page: params[:page], per_page: params[:per_page])
  end
end
