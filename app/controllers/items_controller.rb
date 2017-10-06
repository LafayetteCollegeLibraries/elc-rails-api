class ItemsController < ApplicationController
  def index
    @items = Item.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @item = Item.find(params[:id])
  end
end
