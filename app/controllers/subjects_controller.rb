class SubjectsController < ApplicationController
  def index
    @page = param_page
    @per_page = param_per_page
    @subjects = Subject.paginate(page: @page, per_page: @per_page)
  end

  def search
    @page = param_page
    @per_page = param_per_page
    @subjects = Subject.search(params[:q])
                       .paginate(page: @page, per_page: @per_page)

    render template: 'subjects/index'
  end

  def show
    @subject = Subject.find(params[:id])
  end
end
