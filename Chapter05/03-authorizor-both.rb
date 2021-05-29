class Authorizer
  class InvalidAuthorization < StandardError
  end

  def self.check(user, action)
    unless new(user, action).authorized?
      raise InvalidAuthorization,
      "#{user.name} is not authorized to perform #{action}"
    end
  end

  def self.allowed?(user, action)
    new(user, action).authorized?
  end
end

if Authorizer.allowed?(current_user, :manage_users)
  show_manage_users_page
else
  show_invalid_access_page
end

Authorizer.check(current_user, :manage_users)
show_manage_users_page

begin
  handle_request
rescue Authorizer::InvalidAuthorization
  show_invalid_access_page
end
