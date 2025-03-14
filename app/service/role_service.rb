class RoleService
    def initialize
    end
  
    def all_roles
      Role.all
    end
  
    def find_role(id)
      Role.find_by(id: id)
    end
  
    def create_role(params)
      Role.new(params).tap do |role|
        role.save!
      end
    end
  
    def update_role(role, params)
      role.update(params)
      role
    end
  
    def destroy_role(role)
      role.destroy
    end
  end
  