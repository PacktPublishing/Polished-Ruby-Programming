class Address
  def initialize(street, city, state, zip)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

  def format_label(addressee)
    <<~END
    #{addressee}
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end

class Client
  def initialize(first_name, last_name, address, phone)
    @first_name = first_name
    @last_name = last_name
    @address = address
    @phone = phone
  end

  def update_phone(phone)
    @phone = phone
  end

  def update_address(address)
    @address = address
  end

  def format_address_label
    @address.format_label("#{@first_name} #{@last_name}")
  end
end

class Shipment
  def initialize(contents, ship_date, ship_to, address)
    @contents = contents
    @ship_date = ship_date
    @ship_to = ship_to
    @address = address
  end

  def format_address_label
    @address.format_label(@ship_to)
  end
end
