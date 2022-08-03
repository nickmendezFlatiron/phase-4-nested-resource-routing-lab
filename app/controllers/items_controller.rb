class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound , with: :render_not_found

  def index
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      items = user.items
      render json: items
    else 
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find_by!(id: params[:id])
    render json: item, include: :user
  end

  def create 
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      item = user.items.create!(items_params)
    else  
      item = Item.create!(items_params) 
    end 
    render json: item , status: :created
  end 

  private

  def render_not_found
    render json: {error: "user not found"} , status: :not_found
  end

  def items_params
    params.permit(:name , :description, :price , :user_id)
  end
end
