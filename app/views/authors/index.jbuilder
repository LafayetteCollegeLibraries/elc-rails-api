json.data do
  json.array! @authors, partial: 'authors/author', as: :author
end

json.partial! 'partials/meta', locals: {
  klass: Author,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i,
}