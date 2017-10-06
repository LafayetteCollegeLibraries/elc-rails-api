json.extract! item, :id, :title

json.author do
  if item.author.blank?
    json.null!
  else
    item.author.name
  end
end

json.subjects do
  json.array! item.subjects.map(&:label)
end