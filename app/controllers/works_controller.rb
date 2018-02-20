class WorksController < ApplicationController
  def index
    @page = param_page
    @per_page = param_per_page
    @works = determine_works_source.paginate(page: @page, per_page: @per_page)
  end

  def show
    @work = Work.find(params[:id])
  end

  private

  def determine_works_source
    if params[:author_id]
      Work.by_author(params[:author_id])
    elsif params[:subject_id]
      Work.by_subject(params[:subject_id])
    else
      Work.all
    end
  end
end
