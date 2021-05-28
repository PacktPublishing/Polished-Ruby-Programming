class Employee
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
