class FooController < ApplicationController
  before_action :check_access

  def index
    # ...
  end
  def create
    # ...
  end

  # ...

  private def check_access
    # ...
  end
end

class FooController < ApplicationController
  before_action :check_access, only: [:create]

  # ...
end

class FooController < ApplicationController
  before_action :check_access, except: [:index, :bars]

  # ...
end
