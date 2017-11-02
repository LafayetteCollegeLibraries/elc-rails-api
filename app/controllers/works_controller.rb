class WorksController < ApplicationController
  def index
    page = params[:page]
    per_page = params[:per_page]
    author_id = params[:author_id]
    subject_id = params[:subject_id]

    @works = if author_id
               Work.by_author(author_id)
                   .paginate(page: page, per_page: per_page)
             elsif subject_id
               Work.by_subject(subject_id)
                   .paginate(page: page, per_page: per_page)
             else
               Work.paginate(page: page, per_page: per_page)
             end
  end

  def show
    @work = Work.find(params[:id])
  end
end
