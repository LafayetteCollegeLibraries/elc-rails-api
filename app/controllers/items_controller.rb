class ItemsController < ApplicationController
  def index
    @items = Item.paginate(page: params[:page], per_page: params[:per_page])
  end

  def search
    @items = Item.search(params[:q])
                 .paginate(page: params[:page], per_page: params[:per_page])
    @count = @items.count

    render template: 'items/index'
  end

  def show
    @item = Item.find(params[:id])
  end
end
