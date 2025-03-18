class Api::V1::PermissionsController < ApplicationController
    include Paginatable
  
    before_action :authenticate
    before_action :authorize_permission
  
    def initialize
      @permission_service = PermissionService.new
      super()
    end
  
    # get all permissions
    def index
      permissions = @permission_service.all_permissions
      @permissions = paginate(permissions)
  
      render json: @permissions,
             each_serializer: PermissionSerializer,
             meta: paginate_meta(@permissions),
             adapter: :json,
             status: :ok
    end
  
    def show
      permission = @permission_service.find_permission(params[:id])
  
      raise ActiveRecord::RecordNotFound if permission.nil?
  
      render json: permission,
      serializer: PermissionSerializer,
      adapter: :json,
      status: :ok
  
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: "Permission not found",
        message: "The permission you're looking for doesn't exist."
      }, status: :not_found
  
    rescue StandardError
      render json: {
        error: "Internal server error",
        message: "Something went wrong. Please try again later."
      }, status: :internal_server_error
  
    end
  
    def create
      permission = @permission_service.create_permission(permission_params)
    
      if permission.errors.any?
        raise ActiveRecord::RecordInvalid.new(permission)
      elsif permission.persisted?
        render json: {
          status: :ok,
          data: PermissionSerializer.new(permission),
          message: "Permission created successfully"
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
      permission = @permission_service.find_permission(params[:id])
  
      raise ActiveRecord::RecordNotFound if permission.nil?
  
      updated_permission = @permission_service.update_permission(permission, permission_params)
  
      if updated_permission.errors.any?
        raise ActiveRecord::RecordInvalid.new(updated_permission)
  
      elsif updated_permission.persisted?
        render json: {
          status: :ok,
          data: PermissionSerializer.new(updated_permission),
          message: "Permission updated successfully"
        }
      end
  
      rescue ActiveRecord::RecordNotFound
        render json: {
          error: "Permission not found",
          message: "The permission you're updating doesn't exist."
        }, status: :not_found
    
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
  
  
  
    # delete permission
    def destroy
      permission = @permission_service.find_permission(params[:id])
      raise ActiveRecord::RecordNotFound if permission.nil?
      @permission_service.destroy_permission(permission)
  
      render json: {
        message: "Permission deleted successfully"
      }, status: :no_content
  
      
    rescue ActiveRecord::RecordNotFound
      render json: {
        error: "Permission not found",
        message: "The permission you're updating doesn't exist."
      }, status: :not_found
  
    rescue StandardError
      render json: {
        error: "Internal server error",
        message: "Something went wrong. Please try again later."
      }, status: :internal_server_error
    end
  
    def authorize_permission
      policy = PermissionPolicy.new(current_user)
      action = action_name
  
      unless policy.public_send("#{action}?")
        render json: { error: "You do not have permission to perform this action" }, status: :forbidden
      end
    end
  
    private
  
    def permission_params
      params.require(:permission).permit(:action, :resource)
    end
  end
  