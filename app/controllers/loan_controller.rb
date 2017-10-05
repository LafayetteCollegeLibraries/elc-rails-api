class LoanController < ApplicationController
  def index
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
