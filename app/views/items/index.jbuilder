json.data do
  json.array! @items, partial: 'items/item', as: :item
end

json.partial! 'partials/meta', locals: {
  total: @items.count,
  page: @page.to_i,
  per_page: @per_page.to_i
}
