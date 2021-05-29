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

supervisor = Employee.new("Juan Manuel", "CEO",
                          "246-011-0642", nil)
subordinate = Employee.new("Aziz Karim", "CTO",
                           "707-405-9260", supervisor)

print subordinate.employee_info
# Name: Aziz Karim
# Position: CTO
# Phone: 707-405-9260
# Supervisor Name: Juan Manuel
# Supervisor Position: CEO
# Supervisor Phone: 246-011-0642

print supervisor.employee_info
# NoMethodError
