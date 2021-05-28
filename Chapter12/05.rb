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

  def format_address_label
    <<~END
    #{@ship_to}
    #{@street}
    #{@city}, #{@state} #{@zip}
    END
  end
end
