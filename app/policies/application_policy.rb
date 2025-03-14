class ApplicationPolicy
  attr_reader :user

  def initialize(user)
    puts "user #{user}"
    @user = user
  end

  def resource_name
    raise NotImplementedError, "You must define `resource_name` in your policy"
  end

  def has_permission?(action)
    return false if user.nil?

    user.roles.joins(:permissions).exists?(permissions: { action: action, resource: resource_name })
  end

  def authorize(action)
    return false unless user

    has_permission?(action)
  end
end
