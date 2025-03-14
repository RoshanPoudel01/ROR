class UserSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :username, :email, :role

  def role
    object.role
  end
end
