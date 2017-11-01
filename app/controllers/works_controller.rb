class WorksController < ApplicationController
  def index
    @works = Work.paginate(page: params[:page], per_page: params[:per_page])
  end
end
