class Role < ApplicationRecord
    has_and_belongs_to_many :permissions, join_table: :roles_permissions
    has_and_belongs_to_many :users, join_table: :users_roles
  
    validates :name, presence: true, uniqueness: true
    validates :description, length: { maximum: 250 }
end
