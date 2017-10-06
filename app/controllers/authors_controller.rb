class AuthorsController < ApplicationController
  def index
    @authors = Author.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @author = Author.find(params[:id])
  end
end
