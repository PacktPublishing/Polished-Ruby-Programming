class AbstractEmployee
  attr_reader :name
  attr_reader :position
  attr_reader :phone

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

class Employee < AbstractEmployee
  attr_reader :supervisor

  def initialize(name, position, phone, supervisor)
    @name = name
    @position = position
    @phone = phone
    @supervisor = supervisor
  end
end

class NullEmployee < AbstractEmployee
  def initialize
    @name = ''
    @position = ''
    @phone = ''
  end

  def supervisor
    @supervisor ||= NullEmployee.new
  end

  def employee_info
    supervisor
    super
  end
end

null_employee = NullEmployee.new

null_employee.employee_info
# Name:
# Position:
# Phone:
# Supervisor Name:
# Supervisor Position:
# Supervisor Phone:
