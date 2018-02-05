class ItemsController < ApplicationController
  def index
    work_id = params[:work_id]
    @page = param_page
    @per_page = param_per_page

    @items = Item.where(work: Work.find(work_id))
                 .paginate(page: @page, per_page: @per_page)
  end
end