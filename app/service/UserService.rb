class UserService
    def initialize
    end
  
    def all_users
      User.all
    end
  
    def find_user(id)
      User.find_by(id: id)
    end
  
    def create_user(params)
      User.new(params).tap do |user|
        user.save!
      end
    end
  
    def update_user(user, params)
      user.update(params)
      user
    end
  
    def destroy_user(user)
      user.destroy
    end
  end