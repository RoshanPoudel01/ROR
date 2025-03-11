
class AuthPolicy < ApplicationPolicy
    include Constants
  
    def resource_name
      Constants::AUTH_RESOURCE
    end
  
    def assign_roles?
      has_permission?(Constants::ACTION_ASSIGN_ROLES)
    end
  
    def assign_permissions?
      has_permission?(Constants::ACTION_ASSIGN_PERMISSION)
    end
  end