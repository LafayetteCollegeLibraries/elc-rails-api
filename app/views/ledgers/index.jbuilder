json.data do
  json.array! @ledgers, partial: 'ledgers/ledger_brief', as: :ledger
end

json.partial! 'partials/meta', locals: {
  total: Ledger.count,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i
}
