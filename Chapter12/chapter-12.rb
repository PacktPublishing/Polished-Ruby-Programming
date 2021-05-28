### 12
### Handling Change

## Implementing the most common Ruby refactoring techniques

class Database
  def insert(*args)
    conn = checkout_connection
    conn.execute(insert_sql(*args))
  ensure
    checkin_connection(conn) if conn
  end

# --

  def update(*args)
    conn = checkout_connection
    conn.execute(update_sql(*args))
  ensure
    checkin_connection(conn) if conn
  end

  def delete(*args)
    conn = checkout_connection
    conn.execute(delete_sql(*args))
  ensure
    checkin_connection(conn) if conn
  end
end

# --

class Database
  private def checkout
    conn = checkout_connection
    yield conn
  ensure
    checkin_connection(conn) if conn
  end

# --

  def insert(*args)
    checkout do |conn|
      conn.execute(insert_sql(*args))
    end
  end
  def update(*args)
    checkout do |conn|
      conn.execute(update_sql(*args))
    end
  end
  def delete(*args)
    checkout do |conn|
      conn.execute(delete_sql(*args))
    end
  end
end

# --

class Database
  private def execute
    checkout do |conn|
      conn.execute(yield)
    end
  end

# --

  def insert(*args)
    execute{insert_sql(*args)}
  end

  def update(*args)
    execute{update_sql(*args)}
  end

  def delete(*args)
    execute{delete_sql(*args)}
  end
end

# --

class Database
  private def execute(sql)
    checkout do |conn|
      conn.execute(sql)
    end
  end

# --

  def insert(*args)
    execute(insert_sql(*args))
  end

  def update(*args)
    execute(update_sql(*args))
  end

  def delete(*args)
    execute(delete_sql(*args))
  end
end

# --

class Database
  private def execute(sql)
    conn = checkout_connection
    conn.execute(sql)
  ensure
    checkin_connection(conn) if conn
  end
end

# --

class Client
  def initialize(first_name, last_name, street, city,
                 state, zip, phone)
    @first_name = first_name
    @last_name = last_name
    @street = street
    @city = city
    @state = state
    @zip = zip
    @phone = phone
  end

# --

  def update_phone(phone)
    @phone = phone
  end

  def update_address(street, city, state, zip)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

# --

  def format_address_label
    <<~END
    #{@first_name} #{@last_name}
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end

# --

class Shipment
  def initialize(contents, ship_date, ship_to,
                 street, city, state, zip)
    @contents = contents
    @ship_date = ship_date
    @ship_to = ship_to
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

# --

  def format_address_label
    <<~END
    #{@ship_to}
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end

# --

class Address
  def initialize(street, city, state, zip)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end
end

# --

class Client
  def initialize(first_name, last_name, street, city,
                 state, zip, phone)
    @first_name = first_name
    @last_name = last_name
    @address = Address.new(street, city, state, zip)
    @phone = phone
  end
end

# --

class Shipment
  def initialize(contents, ship_date, ship_to,
                 street, city, state, zip)
    @contents = contents
    @ship_date = ship_date
    @ship_to = ship_to
    @address = Address.new(street, city, state, zip)
  end
end

# --

class Client
  def initialize(first_name, last_name, address, phone)
    @first_name = first_name
    @last_name = last_name
    @address = address
    @phone = phone
  end
end
class Shipment
  def initialize(contents, ship_date, ship_to, address)
    @contents = contents
    @ship_date = ship_date
    @ship_to = ship_to
    @address = address
  end
end

# --

class Client
  def update_address(street, city, state, zip)
    @address = Address.new(street, city, state, zip)
  end
end

# --

class Client
  def update_address(address)
    @address = address
  end
end

# --

class Address
  def format_label
    <<~END
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end

# --

class Client
  def format_address_label
    <<~END
    #{@first_name} #{@last_name}
    #{@address.format_label}
    END
  end
end
class Shipment
  def format_address_label
    <<~END
    #{@ship_to}
    #{@address.format_label}
    END
  end
end

# --

class Address
  def format_label(addressee)
    <<~END
    #{addressee}
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end

# --

class Client
  def format_address_label
    @address.format_label("#{@first_name} #{@last_name}")
  end
end
class Shipment
  def format_address_label
    @address.format_label(@ship_to)
  end
end

## Removing features properly

def method_to_be_removed
  warn("#{__callee__} is deprecated",
       uplevel: 1, category: :deprecated)
  # ...
end

# --

def method_to_be_removed
  warn("#{__callee__} is deprecated",
       uplevel: 1, category: :deprecated)
  _method_to_be_removed
end

private def _method_to_be_removed
  # ...
end

# --

def arg_to_be_removed(arg)
  # ...
end

# --

def arg_to_be_removed(arg=(arg_not_given=true; nil))
  unless arg_not_given
    warn("Passing deprecated argument to #{__callee__}",
         uplevel: 1, category: :deprecated)
  end

  # ...
end

# --

def arg_to_be_added(arg,
                           arg2=(arg2_not_given=true; nil))
  if arg2_not_given
    warn("Should now pass 2 arguments to #{__callee__}",
         uplevel: 1, category: :deprecated)
  end

  # ...
end

# --

class Foo
  BAR = 1
  deprecate_constant :BAR
end

# --

class Foo
  BAR = 1
  BAR_ = BAR
  private_constant :BAR_
  deprecate_constant :BAR
end

# --

class Object
  Foo_ = Foo
  private_constant :Foo_
  deprecate_constant :Foo
end
