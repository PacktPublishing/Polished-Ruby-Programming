class Address
  def initialize(street, city, state, zip)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

  def format_label
    <<~END
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end

class Client
  def initialize(first_name, last_name, street, city,
                 state, zip, phone)
    @first_name = first_name
    @last_name = last_name
    @address = Address.new(street, city, state, zip)
    @phone = phone
  end

  def update_phone(phone)
    @phone = phone
  end

  def update_address(street, city, state, zip)
    @address = Address.new(street, city, state, zip)
  end

  def format_address_label
    <<~END
    #{@first_name} #{@last_name}
    #{@address.format_label}
    END
  end
end

class Shipment
  def initialize(contents, ship_date, ship_to,
                 street, city, state, zip)
    @contents = contents
    @ship_date = ship_date
    @ship_to = ship_to
    @address = Address.new(street, city, state, zip)
  end

  def format_address_label
    <<~END
    #{@ship_to}
    #{@address.format_label}
    END
  end
end
