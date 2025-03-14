class PermissionService
    def all_permissions()
      Permission.all
    end
  
    def find_permission(id)
      Permission.find_by(id: id)
    end
  
    def create_permission(params)
      Permission.create(params)
    end
  
    def update_permission(permission, params)
      permission.update(params)
      permission
    end
  
    def destroy_permission(permission)
      permission.destroy
    end
  end
  