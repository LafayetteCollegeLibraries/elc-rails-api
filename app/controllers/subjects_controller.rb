class SubjectsController < ApplicationController
  def index
    @subjects = Subject.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @subject = Subject.find(params[:id])
  end
end
