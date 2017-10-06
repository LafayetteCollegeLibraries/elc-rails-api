json.data do
  json.array! @loans, partial: 'loans/loan_brief', as: :loan
end

json.partial! 'partials/meta', locals: {
  klass: Loan,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i,
}