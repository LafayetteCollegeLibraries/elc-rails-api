class PatronsController < ApplicationController
  def index
    @patrons = Patron.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @patron = Patron.find(params[:id])
  end

  def search
    @patrons = Patron.search(params[:q])
                     .paginate(page: params[:page], per_page: params[:per_page])
    @count = @patrons.count

    render template: 'patrons/index'
  end
end
