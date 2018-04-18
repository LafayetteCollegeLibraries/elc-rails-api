class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found(error)
    render json: { error: error.message, status: 404 }, status: 404
  end

  def param_unless_zero(value, default)
    val = value.to_i

    return val unless val.zero?

    default
  end

  def param_page
    param_unless_zero(params[:page], 1)
  end

  def param_per_page
    param_unless_zero(params[:per_page], WillPaginate.per_page)
  end
end
