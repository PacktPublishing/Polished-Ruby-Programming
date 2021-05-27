### Robust Web Application Security

## Trusting input never

Fruit = Struct.new(:type, :color, :price)

# --

FRUITS = {}
FRUITS[1] = Fruit.new('apple', 'red', 0.70)
FRUITS[2] = Fruit.new('pear', 'green', 1.23)
FRUITS[3] = Fruit.new('banana', 'yellow', 1.40)

# --

Roda.route do |r|
  r.get "fruit", Integer, String do |fruit_id, field|
    FRUITS[fruit_id].send(field).to_s
  end
end

# --

# GET /fruit/1/exit

# --

Roda.route do |r|
  r.get "fruit", Integer, String do |fruit_id, field|
    next if field == "exit"
    FRUITS[fruit_id].send(field).to_s
  end
end

# --

# GET /fruit/1/exit!

# --

Roda.route do |r|
  r.get "fruit", Integer, String do |fruit_id, field|
    next unless %w[type color price].include?(field)
    FRUITS[fruit_id].send(field).to_s
  end
end

# --

Roda.route do |r|
  r.is "fruit", Integer, String do |fruit_id, field|
    r.get do
      next unless %w[type color price].include?(field)
      FRUITS[fruit_id].send(field).to_s
    end

    r.post do
      next unless %w[type color].include?(field)
      FRUITS[fruit_id].send("#{field}=", r.params['value'])
      r.redirect
    end
  end
end

# --

r.post do
  next unless %w[type color].include?(field)
  FRUITS[fruit_id].send("#{field}=",
                        r.params['value'].to_s)
  r.redirect
end

## Performing access control at highest level possible

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

# --

class FooController < ApplicationController
  before_action :check_access, only: [:create]

  # ...
end

# --

class FooController < ApplicationController
  before_action :check_access, except: [:index, :bars]

  # ...
end

# --

class ApplicationController < ActionController::Base
  before_action :require_login

  # ...
end

# --

class BarController < ApplicationController
  skip_before_action :require_login, only: [:index, :bars]

  # ...
end

# --

before '/foos/(create|bazs)' do
  check_access
end

# --

Roda.route do |r|
  r.on "foo" do
    r.get "index" do
      # ...
    end
    # ...

    check_access

    r.get "create" do
      # ...
    end
    # ...
  end
end

## Avoiding injection

# In your ERB code:
# <p>Added by: <%= params['name'] %></p>

# --

# In your ERB code:
# <p>Last update by: <%= Account.last_update_by.name %></p>

# --

# In your ERB code:
# <p>Added by: <%== params['name'] %></p>

# --

require 'erubi'
set :erb, escape_html: true

# --

Roda.plugin :render, escape: true

# --

Foo.where("bar > #{value}").first

# --

Foo.where("bar > ?", value).first

# --

Foo.where(Sequel[:bar] > value).first

# --

Foo.where("bar > #{value}").first
# raises Sequel::Error, Invalid filter expression

# --

class Bar
  def self.column_accessor(name)
    class_eval(<<-END, __FILE__, __LINE__+1)
      def #{name}
        columns.#{name}
      end
    END
  end
end

## Approaching high security environments

worker_exec true

# --

require 'unveil'
Pledge.unveil('views' => 'r')

# --

require 'pledge'
Pledge.pledge('rpath inet unix')
