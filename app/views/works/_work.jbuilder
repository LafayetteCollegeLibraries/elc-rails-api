json.extract! work, :id, :title

json.author do
  if work.authors.blank?
    json.array! []
  else
    json.array! work.authors, partial: 'authors/author', as: 'author'
  end
end

json.subjects do
  json.array! work.subjects, partial: 'subjects/subject', as: 'subject'
end
