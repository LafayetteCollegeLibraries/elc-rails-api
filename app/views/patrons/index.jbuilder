json.data do
  json.array! @patrons, partial: 'partials/person', as: :person
end

json.partial! 'partials/meta', locals: {
  total: @count || Patron.count,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i
}
