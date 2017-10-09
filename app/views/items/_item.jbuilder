json.extract! item, :id, :title

json.author do
  if item.author.blank?
    json.null!
  else
    json.partial! 'authors/author', author: item.author
  end
end

json.subjects do
  json.array! item.subjects, partial: 'subjects/subject', as: 'subject'
end