class LoansController < ApplicationController
  def index
    @loans = Loan.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    id = params[:id]

    if (id == 'random')
      redirect_to Loan.random
    else
      @loan = Loan.find(id)
    end
  end
end
