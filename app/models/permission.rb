class Permission < ApplicationRecord
    has_and_belongs_to_many :roles, join_table: :roles_permissions

    validates :action, presence: true
    validates :resource, presence: true
end
