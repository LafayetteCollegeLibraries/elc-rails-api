class LoansController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: LoanDatatable.new(view_context) }
    end
  end

  def show
    @loan = Loan.find(params[:id])
  end
end
