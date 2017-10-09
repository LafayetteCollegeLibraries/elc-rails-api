json.data do
  json.array! @items, partial: 'items/item', as: :item
end

json.partial! 'partials/meta', locals: {
  total: @count || Item.count,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i,
}