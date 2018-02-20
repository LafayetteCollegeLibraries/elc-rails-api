json.data do
  json.array! @loans, partial: 'loans/loan', as: :loan
end

json.partial! 'partials/meta', locals: {
  total: @ledger ? @ledger.loans.count : @loans.count,
  page: @page.to_i,
  per_page: @per_page.to_i
}
