class Api::V1::RolesController < ApplicationController
    include Paginatable
    before_action :authenticate

    def initialize
        @role_service = RoleService.new
    end

    def index
        roles = @role_service.all_roles
        @roles = paginate(roles)
        render json: @roles, each_serializer: RoleSerializer, meta: paginate_meta(@roles) ,adapter: :json, status: :ok
    end

    def create
        role = @role_service.create_role(roles_params)
        if role.errors.any?
            raise ActiveRecord::RecordInvalid.new(role)
        elsif role.persisted?
            render json: {
                message: "Role created successfully",
                data: RoleSerializer.new(role),
                status: :created
            }
        end
        rescue ActiveRecord::RecordInvalid => e
            render json: {
                error: "Validation failed",
                message: "Please check the provided data.",
                details: e.record.errors.full_messages
            },staus: :unprocessable_entity
        rescue StandardError
            render json: {
                error: "Internal server error",
                message: "Something went wrong. Please try again later."
            }, status: :internal_server_error
    end

    def show
        @role = @role_service.find_role(params[:id])
        raise ActiveRecord::RecordNotFound if @role.nil?
        render json: @role, serializer: RoleSerializer, adapter: :json, status: :ok
        rescue ActiveRecord::RecordNotFound
            render json: {
                error: "Role not found",
                message: "The role you are looking for does not exist."
            }, status: :not_found
        rescue StandardError
            render json: {
                error: "Internal server error",
                message: "Something went wrong. Please try again later."
            }, status: :internal_server_error
    end

    def update
        role = @role_service.find_role(params[:id])
        raise ActiveRecord::RecordNotFound if role.nil?
        updated_role = @role_service.update_role(role, roles_params)
        if updated_role.errors.any?
            raise ActiveRecord::RecordInvalid.new(updated_role)
        elsif updated_role.persisted?
            render json: {
                message: "Role updated successfully",
                data: RoleSerializer.new(updated_role),
                status: :ok
            }
        end
        rescue ActiveRecord::RecordInvalid => e
            render json: {
                error: "Validation failed",
                message: "Please check the provided data.",
                details: e.record.errors.full_messages
            }, status: :unprocessable_entity
        rescue ActiveRecord::RecordNotFound
            render json: {
                error: "Role not found",
                message: "The role you are looking for does not exist."
        },staus: :not_found
        rescue StandardError
        render json: {
            error: "Internal server error",
            message: "Something went wrong. Please try again later."
        }, status: :internal_server_error
    end

    def destroy
        role = @role_service.find_role(params[:id])
        raise ActiveRecord::RecordNotFound if role.nil?
        @role_service.destroy_role(role)
        render json: {
            message: "Role deleted successfully",
            status: :ok
        }
        rescue ActiveRecord::RecordNotFound
            render json: {
                error: "Role not found",
                message: "The role you are looking for does not exist."
            }, status: :not_found
        rescue StandardError=>e
            render json: {
                error: "Internal server error",
                message: e.to_s
            }, status: :internal_server_error
    end
    private
    def roles_params
        params.require(:role).permit(:name, :description)
    end
end
