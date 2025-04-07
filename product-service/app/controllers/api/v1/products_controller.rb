class Api::V1::ProductsController < Api::V1::ApplicationController
  skip_before_action :authorize_user

  def index
    permitted_params = params.permit(:owner_id, :name, :price_min, :price_max, :page, :per_page)
    query = Queries::Products.new(Product.all, permitted_params)

    render json: query.call
  end

  def show
    render json: Product.find(params[:id])
  end
end
