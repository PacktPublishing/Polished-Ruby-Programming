class Authorizer
  def self.check(user, action)
    new(user, action).authorized?
  end

  def authorized?
    return true if user.admin?
    return true if action == :view_own_profile
    false
  end
end

if Authorizer.check(current_user, :manage_users)
  show_manage_users_page
else
  show_invalid_access_page
end

Authorizer.check(current_user, :manage_users)
show_manage_users_page
