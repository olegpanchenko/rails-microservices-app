class Api::V1::ApplicationController < ApplicationController
  include Authorization
  skip_before_action :verify_authenticity_token
  # after_action :set_csrf_header

  rescue_from ActiveRecord::RecordInvalid, with: :jsonapi_render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found

  private
  def jsonapi_render_unprocessable_entity(exception)
    # exception.record
    render json: { errors: [ title: exception.message, code: 422, status: 422 ] }, status: :unprocessable_entity
  end

  def jsonapi_render_not_found(exception)
    render json: { errors: [ title: "Record not found", code: 404, status: 404 ] }, status: :not_found
  end
end
