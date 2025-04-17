class Api::V1::OrdersController < Api::V1::ApplicationController
  before_action :init_order, only: %i[show update]

  def index
    permitted_params = params.permit(:status)
    query = Queries::Orders.new(current_user.orders, permitted_params)

    render json: query.call
  end

  def show
    render json: @order
  end

  def create
    order = current_user.orders.create
    render json: order
  end

  def update
    @order.update!(process_params[:data][:attributes])
    render json: @order
  end

  private
  def init_order
    @order = current_user.orders.find(params[:id])
  end

  def process_params
    params.permit(
      data: [
        :id,
        :type,
        attributes: [
          :status
        ]
      ]
    )
  end
end
