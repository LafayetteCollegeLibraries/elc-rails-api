json.data do
  json.array! @works, partial: 'works/work', as: :work
end

json.partial! 'partials/meta', locals: {
  total: @works.count,
  page: @page,
  per_page: @per_page
}
