json.data do 
  json.array! @subjects, partial: 'subjects/subject', as: :subject
end

json.partial! 'partials/meta', locals: {
  klass: Subject,
  page: (params[:page] || 1).to_i,
  per_page: (params[:per_page] || WillPaginate.per_page).to_i,
}