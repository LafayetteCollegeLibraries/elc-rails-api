json.data do
  json.array! @works, partial: 'works/work', as: :work
end

json.partial! 'partials/meta', locals: {
  total: @count || Work.count,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i,
}