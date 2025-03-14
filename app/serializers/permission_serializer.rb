class PermissionSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :updated_at, :action, :resource
  end
  