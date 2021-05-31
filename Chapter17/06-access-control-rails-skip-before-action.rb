class ApplicationController < ActionController::Base
  before_action :require_login

  # ...
end

class BarController < ApplicationController
  skip_before_action :require_login, only: [:index, :bars]

  # ...
end
