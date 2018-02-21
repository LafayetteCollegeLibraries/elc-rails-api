json.meta do
  json.total total
  json.page page
  json.per_page per_page
  json.total_pages((total / per_page.to_f).ceil)
end
