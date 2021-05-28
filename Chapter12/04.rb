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

  def update_phone(phone)
    @phone = phone
  end

  def update_address(street, city, state, zip)
    @street = street
    @city = city
    @state = state
    @zip = zip
  end

  def format_address_label
    <<~END
    #{@first_name} #{@last_name}
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end
