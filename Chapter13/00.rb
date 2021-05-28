class Employee
  attr_reader :name
  attr_reader :position
  attr_reader :phone

  def initialize(name, position, phone, supervisor)
    @name = name
    @position = position
    @phone = phone
    @supervisor = supervisor
  end

  def employee_info
    <<~END
    Name: #{@name}
    Position: #{@position}
    Phone: #{@phone}
    Supervisor Name: #{@supervisor.name}
    Supervisor Position: #{@supervisor.position}
    Supervisor Phone: #{@supervisor.phone}
    END
  end
end
