json.data do
  json.array! @loans, partial: 'loans/loan', as: :loan
end

json.partial! 'partials/meta', locals: {
  total: @ledger ? @ledger.loans.count : Loan.count,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i,
}