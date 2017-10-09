class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
    def not_found(error)
      render json: { error: error.message, status: 404 }, status: 404
    end
end
