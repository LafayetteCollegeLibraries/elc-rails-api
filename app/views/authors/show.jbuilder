json.partial! 'authors/author', author: @author
json.works do
  json.array! @author.works, partial: 'works/work', as: :work
end
