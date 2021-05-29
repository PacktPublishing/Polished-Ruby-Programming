class AbstractEmployee
  attr_reader :name
  attr_reader :position
  attr_reader :phone

  def specific_employee_info
    <<~END
    Name: #{@name}
    Position: #{@position}
    Phone: #{@phone}
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

  def employee_info
    if @supervisor.is_a?(Employee)
      specific_employee_info +
        @supervisor.specific_employee_info
    else
      specific_employee_info
    end
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

supervisor = Employee.new("Juan Manuel", "CEO",
                          "246-011-0642", NullEmployee.new)
supervisor.employee_info
# Name: Juan Manuel
# Position: CEO
# Phone: 246-011-0642
