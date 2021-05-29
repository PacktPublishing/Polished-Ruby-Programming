class Employee
  attr_reader :supervisor

  def initialize(name, position, phone, supervisor)
    @name = name
    @position = position
    @phone = phone
    @supervisor = supervisor
  end

  def specific_employee_info
    <<~END
    Name: #{@name}
    Position: #{@position}
    Phone: #{@phone}
    END
  end

  def employee_info
    if @supervisor
      specific_employee_info +
        @supervisor.specific_employee_info
    else
      specific_employee_info
    end
  end
end

supervisor = Employee.new("Juan Manuel", "CEO",
                          "246-011-0642", nil)
supervisor.employee_info
# Name: Juan Manuel
# Position: CEO
# Phone: 246-011-0642
