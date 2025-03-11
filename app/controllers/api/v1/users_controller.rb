class Api::V1::UsersController < ApplicationController
  include Paginatable
  before_action :authenticate
  skip_before_action :authenticate, only: [:create]

  def index
    users = User.all
    @users = paginate(users)
    render json: @users, each_serializer: UserSerializer, meta: paginate_meta(@users), adapter: :json, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: user, serializer: UserSerializer, adapter: :json, status: :ok
  rescue ActiveRecord::RecordNotFound
    rnder json: { error: "User not found" }, staus: :not_found
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, serializer: UserSerializer, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user, serializer: UserSerializer, status: :ok
    else
      render json: {
               errors: user.errors.full_messages,
             }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { message: "User deleted" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end
end
