class PatronsController < ApplicationController
  def index
    @patrons = Patron.paginate(page: params[:page], per_page: params[:per_page])
  end
end
