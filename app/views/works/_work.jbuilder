json.extract! work, :id, :title

json.author do
  if work.author.blank?
    json.null!
  else
    json.partial! 'authors/author', author: work.author
  end
end

json.subjects do
  json.array! work.subjects, partial: 'subjects/subject', as: 'subject'
end
