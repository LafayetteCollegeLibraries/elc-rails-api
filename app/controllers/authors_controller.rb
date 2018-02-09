class AuthorsController < ApplicationController
  def index
    @authors = Author.paginate(page: params[:page], per_page: params[:per_page])
  end

  def search
    @authors = Author.search(params[:q])
                     .paginate(page: params[:page], per_page: params[:per_page])
    
    @total = @authors.count

    render template: "authors/index"
  end

  def show
    @author = Author.find(params[:id])
  end
end
