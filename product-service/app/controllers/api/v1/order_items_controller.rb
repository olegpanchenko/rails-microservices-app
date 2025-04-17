class Api::V1::OrderItemsController < Api::V1::ApplicationController
  before_action :init_item, only: %i[show update destroy]

  def index
    render json: current_user.orders.find(params[:order_id]).order_items
  end

  def show
    render json: @order_item
  end

  def create
    order_item = OrderItems::Create.call(process_params[:data][:attributes], process_params[:data][:relationships])
    render json: order_item
  end

  def update
    order_item = OrderItems::Update.call(@order_item, process_params[:data][:attributes])
    render json: order_item
  end

  def destroy
    order_item = OrderItems::Delete.call(@order_item)
    render json: order_item
  end

  private
  def init_item
    @order_item = current_user.orders.find(params[:order_id]).order_items.find(params[:id])
  end

  def process_params
    params.permit(
      data: [
        :id,
        :type,
        attributes: [
          :quantity
        ],
        relationships: [
          order: {
            data: [ :id, :type ]
          },
          product: {
            data: [ :id, :type ]
          }
        ]
      ]
    )
  end
end
