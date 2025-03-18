class Api::V1::AuthController < ApplicationController
    before_action :authenticate, only: [:assign_roles, :assign_permissions]
    before_action :authorize, only: [:assign_roles, :assign_permissions]
    def initialize
        @user_service=UserService.new
        @role_service=RoleService.new
        super()
    end

    #User Login
    def login
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            auth_service = AuthenticationService.new(user)
            render json: {
                access_token: auth_service.generate_access_token,
                refresh_token: auth_service.generate_refresh_token,
                user:{
                    id: user.id,username: user.username,email: user.email
                }
            },status: :ok
        else
            render json:{
                error: "Invalid username or password",
            },status: :internal_server_error
        end
    end

    # Refresh Access Token
    def refresh_token
        token = params[:refresh_token]
        payload = JwtService.decode(token)
        if payload && payload[:type] == "refresh" && (user = User.find_by(id: payload[:user_id]))
            auth_service = AuthenticationService.new(user)
            render json: {
                access_token: auth_service.generate_access_token
            },status: :ok
        else
            render json: {
                error: "Invalid or expired refresh token"
            },status: :unauthorized
        end
    end

    #Assingn Roles to user
    def assign_roles
        user = @user_service.find_user(params[:user_id])
        if user.nil?
            render json: {
                status: "error",
                message: "User not found"
            }, status: :not_found
        end
        role_ids = params[:role_ids]

        if role_ids.blank?
            clear_roles(user)
        else
            assign_roles_to_user(user,role_ids)
        end
    end

    #Assign Permissions to user
    def assign_permissions
        role = @role_service.find_role(params[:role_id])

        if role.nil?
            return render json: {
                status: "error",
                message: "Role not found"
            },status: :not_found
        end
        
        permission_ids=params[:permission_ids]

        if permission_ids.blank?
            clear_permissions(role)
        else
            assign_permissions_to_role(role,permission_ids)
        end
    end
    # Authorization Logic
    def authorize
        policy = AuthPolicy.new(current_user)
        action = action_name
        # unless policy.public_send("#{action?}")
        #     render json: {
        #         error: "You do not have persmission to perform this action"
        #     },status: :forbidden
        # end
    end

    private 

    def clear_roles(user)
        user.roles.clear
        if user.save
          render json: { status: "success", data: user.roles, message: "All roles removed successfully" }, status: :ok
        else
          render json: { status: "error", message: "Failed to remove roles" }, status: :unprocessable_entity
        end
      end
    
      def clear_permissions(role)
        role.permissions.clear
        if role.save
          render json: { status: "success", data: role.permissions, message: "All permissions removed successfully" }, status: :ok
        else
          render json: { status: "error", message: "Failed to remove permissions" }, status: :unprocessable_entity
        end
      end
    
      def assign_roles_to_user(user, role_ids)
        roles = Role.where(id: role_ids)
    
        if roles.empty?
          render json: { status: "error", message: "No valid roles found" }, status: :unprocessable_entity
        else
          user.roles.clear
          user.roles << roles
          if user.save
            render json: { status: "success", data: user.roles, message: "Roles updated successfully" }, status: :ok
          else
            render json: { status: "error", message: "Failed to update roles" }, status: :unprocessable_entity
          end
        end
      end
    
      def assign_permissions_to_role(role, permission_ids)
        permissions = Permission.where(id: permission_ids)
    
        if permissions.empty?
          render json: { status: "error", message: "No valid permissions found" }, status: :unprocessable_entity
        else
          role.permissions.clear
          role.permissions << permissions
          if role.save
            render json: { status: "success", data: role.permissions, message: "Permissions updated successfully" }, status: :ok
          else
            render json: { status: "error", message: "Failed to update permissions" }, status: :unprocessable_entity
          end
        end
      end
    
      def user_params
        params.permit(:username, :password, :refresh_token, :user_id, role_ids: [])
      end
    
end
