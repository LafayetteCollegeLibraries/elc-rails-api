class SubjectsController < ApplicationController
  def index
    @subjects = Subject.paginate(page: params[:page], per_page: params[:per_page])
  end

  def search
    @subjects = Subject.search(params[:q])
                       .paginate(page: params[:page], per_page: params[:per_page])
    @count = @subjects.count

    render template: 'subjects/index'
  end

  def show
    @subject = Subject.find(params[:id])
  end
end
