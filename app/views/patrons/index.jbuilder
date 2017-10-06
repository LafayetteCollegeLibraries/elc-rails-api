json.partial! 'partials/meta', locals: {
  total: Patron.count,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i,
}