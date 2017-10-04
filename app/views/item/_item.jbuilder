json.extract! item, :id, :title

json.author do
  if item.author.blank?
    json.null!
  else
    json.partial! 'author/author', author: item.author
  end
end

json.subjects do
  json.array! item.subjects, partial: 'subject/subject', as: 'subject'
end