class Api::V1::UsersController < ApplicationController
  include Paginatable
  before_action :authenticate
  skip_before_action :authenticate, only: [ :create ]

  def initialize
    @user_service = UserService.new
    super()
  end

  def index
  users = @user_service.all_users
    @users = paginate(users)
    render json: @users, each_serializer: UserSerializer, meta: paginate_meta(@users), adapter: :json, status: :ok
    end

  def show
    user = @user_service.find_user(params[:id])

    raise ActiveRecord::RecordNotFound if user.nil?
    render json: user, serializer: UserSerializer, adapter: :json, status: :ok
    
    rescue ActiveRecord::RecordNotFound
      render json: {
        error:"User not found",
        message: "The user you are looking for does not exist."
      }
    rescue StandardError => e
    render json: {
      error: "Internal server error",
      message: "Something went wrong. Please try again later."
    }, status: :internal_server_error
  end

  def create
    user = @user_service.create_user(user_params)
    if user.errors.any?
      raise ActiveRecord::RecordInvalid.new(user)
    elsif user.persisted?
      render json: {
        message: "User created successfully",
        data: UserSerializer.new(user),
        status: :created
      }
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      error: "Validation failed",
      message: "Please check the provided data.",
      details: e.record.errors.full_messages
    }, status: :unprocessable_entity
  rescue StandardError => e
    render json: {
      error: "Internal server error",
      message: "Something went wrong. Please try again later."
    }, status: :internal_server_error
  end

  def update
    user = @user_service.find_user(params[:id])
    raise ActiveRecord::RecordNotFound if user.nil?
    updated_user = @user_service.update_user(user, user_params)

    if updated_user.errors.any?
      raise ActiveRecord::RecordInvalid.new(updated_user)
    elsif updated_user.persisted?
      render json: {
        status: :ok,
        data: UserSerializer.new(updated_user),
        message: "User updated successfully"
      }
    end
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: "User not found",
        message: "The user you are looking for does not exist."
      },status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: {
        error: "Validation failed",
        message: "Please check the provided data.",
        details: e.record.errors.full_messages
      }, status: :unprocessable_entity
    rescue StandardError => e
      render json: {
        error: "Internal server error",
        message: "Something went wrong. Please try again later."
      }, status: :internal_server_error
  end

  def destroy
    user = @user_service.find_user(params[:id])
    raise ActiveRecord::RecordNotFound if user.nil?
    @user_service.destroy_user(user)
    render json: {
      message: "User deleted successfully"
    },status: :no_content

    rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found",message: 'The user you are looking for doesnot exist' }, status: :not_found
  
    rescue StandardError
    render json:{
      error: "Internal server error",
      message: "Something went wrong. Please try again later."
    }, status: :internal_server_error

  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end
end
