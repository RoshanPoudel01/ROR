class RoleSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :updated_at, :name, :description
  end
  