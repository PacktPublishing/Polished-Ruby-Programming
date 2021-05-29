class Authorizer
  class InvalidAuthorization < StandardError
  end

  def self.check(user, action)
    unless new(user, action).authorized?
      raise InvalidAuthorization,
      "#{user.name} is not authorized to perform #{action}"
    end
  end
end

if Authorizer.check(current_user, :manage_users)
  show_manage_users_page
else
  show_invalid_access_page
end

begin
  Authorizer.check(current_user, :manage_users)
rescue Authorizer::InvalidAuthorization
  # don't show link
else
  display_manage_users_link
end
