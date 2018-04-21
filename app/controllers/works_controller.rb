class WorksController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: WorkDatatable.new(view_context) }
    end
  end

  def show
    @work = Work.find(params[:id])
  end
end
