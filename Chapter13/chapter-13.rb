### 13
### Using Common Design Patterns

## Learning about many design patterns that are built into Ruby

class Foo
end

# --

foo_class = Class.new

foo_class.define_method(:bar) do
  2
end

foo_instance = foo_class.new

foo_instance.bar
# => 2

# --

foo_proto = Object.new

foo_proto.define_singleton_method(:bar) do
  2
end

foo_clone = foo_proto.clone

foo_clone.bar
# => 2

# --

foo_class = Class.new

foo_class.define_method(:bar) do
  2
end

foo_class_clone = foo_class.clone

foo_class_clone_instance = foo_class_clone.new

foo_class_clone_clone = foo_class_clone_instance.clone

foo_class_clone_clone.bar
# => 2

# --

class Foo
  @bar = 1
end

# --

class Foo
  def self.bar
    2
  end
  private_class_method :bar
end

# --

class Foo
  def self.bar
    raise TypeError, "not Foo" unless Foo == self
    2
  end
  private_class_method :bar
end

# --

class Foo
  BAR = 3
  private_constant :BAR
end

# --

require 'forwardable'

class Proxy
  extend Forwardable

  def initialize(value)
    @value = value
  end

  def_delegator :@value, :to_s
end

Proxy.new(1).to_s
# => "1"

# --

require 'delegate'

class Proxy2 < SimpleDelegator
  def add_3
    self + 3
  end
end

Proxy2.new(1).add_3
# => 4

# --

class HashProxy < DelegateClass(Hash)
  def size_squared
    size ** 2
  end
end

HashProxy.new(a: 1, b: 2, c: 3).size_squared
# => 9

## Handling cases where there can be only one

require 'singleton'

class OnlyOne
  include Singleton

  def foo
    :foo
  end
end

only1 = OnlyOne.instance
only2 = OnlyOne.instance

only1.equal?(only2)
# => true

# --

OnlyOne = Object.new

# --

def OnlyOne.foo
  :foo
end

# --

Object.autoload :OnlyOne, 'only_one'

## Dealing with nothing

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

# --

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

# --

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

# --

print supervisor.employee_info
# NoMethodError

# --

class Employee
  def employee_info
    <<~END
    Name: #{@name}
    Position: #{@position}
    Phone: #{@phone}
    Supervisor Name: #{@supervisor&.name}
    Supervisor Position: #{@supervisor&.position}
    Supervisor Phone: #{@supervisor&.phone}
    END
  end
end

# --

print supervisor.employee_info
# Name: Juan Manuel
# Position: CEO
# Phone: 246-011-0642
# Supervisor Name:
# Supervisor Position:
# Supervisor Phone:

# --

class NullEmployee
  def name
    ""
  end

  def position
    ""
  end

  def phone
    ""
  end
end

# --

supervisor = Employee.new("Juan Manuel", "CEO",
                          "246-011-0642",
                          NullEmployee.new)

# --

print supervisor.employee_info
# Name: Juan Manuel
# Position: CEO
# Phone: 246-011-0642
# Supervisor Name:
# Supervisor Position:
# Supervisor Phone:

# --

Employee.attr_reader :supervisor

# --

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

# --

class Employee < AbstractEmployee
  attr_reader :supervisor

  def initialize(name, position, phone, supervisor)
    @name = name
    @position = position
    @phone = phone
    @supervisor = supervisor
  end
end

# --

class NullEmployee < AbstractEmployee
  def initialize
    @name = ''
    @position = ''
    @phone = ''
    @supervisor = NullEmployee.new
  end
end

# --

employee.phone << "x1008"

# --

NullEmployee.new
# SystemStackError

# --

class NullEmployee
  def initialize
    @name = ''
    @position = ''
    @phone = ''
  end

  def supervisor
    @supervisor ||= NullEmployee.new
  end
end

# --

null_employee = NullEmployee.new

# --

null_employee.employee_info
# NoMethodError

# --

class NullEmployee
  def employee_info
    supervisor
    super
  end
end

# --

null_employee.employee_info
# Name:
# Position:
# Phone:
# Supervisor Name:
# Supervisor Position:
# Supervisor Phone:

# --

class Employee
  def specific_employee_info
    <<~END
    Name: #{@name}
    Position: #{@position}
    Phone: #{@phone}
    END
  end

# --

  def employee_info
    if @supervisor
      specific_employee_info +
        @supervisor.specific_employee_info
    else
      specific_employee_info
    end
  end
end

# --

supervisor = Employee.new("Juan Manuel", "CEO",
                          "246-011-0642", nil)
supervisor.employee_info
# Name: Juan Manuel
# Position: CEO
# Phone: 246-011-0642

# --

class Employee
  def employee_info
    if @supervisor.is_a?(Employee)
      specific_employee_info +
        @supervisor.specific_employee_info
    else
      specific_employee_info
    end
  end
end

## Visiting objects

class ArbitraryVisitor
  def visit(obj)
    case obj
    when Integer
      visit_integer(obj)
    when String
      visit_string(obj)
    when Array
      visit_array(obj)
    else
      raise ArgumentError, "unsupported object visited"
    end
  end

# --

  private

  def visit_integer(obj)
    obj ** obj
  end

  def visit_string(obj)
    obj + obj.reverse
  end

  def visit_array(obj)
    obj.size
  end
end

# --

av = ArbitraryVisitor.new

av.visit(4)
# => 256

av.visit("palindrome")
# => "palindromeemordnilap"

av.visit([:a, :b, :c])
# => 3

# --

class HashedArbitraryVisitor < ArbitraryVisitor
  DISPATCH = {
    Integer => :visit_integer,
    String => :visit_string,
    Array => :visit_array,
  }.freeze

  def visit(obj)
    if meth = DISPATCH[obj.class]
      send(meth, obj)
    else
      raise ArgumentError, "unsupported object visited"
    end
  end
end

# --

hav = HashedArbitraryVisitor.new

hav.visit([:a, :b, :c])
# => 3

hav.visit(Class.new(Array)[:a, :b, :c])
# ArgumentError

# --

class HashedArbitraryVisitor
  def visit(obj)
    klass = obj.class
    if meth = DISPATCH[klass]
      send(meth, obj)
    else
      while klass = klass.superclass
        if meth = DISPATCH[klass]
          return send(meth, obj)
        end
      end
      raise ArgumentError, "unsupported object visited"
    end
  end
end

# --

hav = HashedArbitraryVisitor.new

hav.visit([:a, :b, :c])
# => 3

hav.visit(Class.new(Array)[:a, :b, :c])
# => 3

## Adapting and strategizing

class Adapter
  def initialize(conn)
    @conn = conn
  end
end

# --

class Adapter::M < Adapter
  def execute(sql)
    @conn.exec(sql)
  end
end
class Adapter::P < Adapter
  def execute(sql)
    @conn.execute_query(sql)
  end
end
class Adapter::S < Adapter
  def execute(sql)
    @conn.exec_sql(sql)
  end
end

# --

class MultiInsert
  def initialize(table, rows)
    @table = table
    @rows = rows
  end
end

# --

class MultiInsert::MultipleQueries < MultiInsert
  def format_sqls
    prefix = "INSERT INTO #{@table} VALUES ("
    @rows.map do |row|
      ["#{prefix}#{row.join(', ')})"]
    end
  end
end

# --

class MultiInsert::SingleQuery < MultiInsert
  def format_sqls
    sql = "INSERT INTO #{@table} VALUES "
    first_row, *rows = @rows
    sql << "(#{first_row.join(', ')})"
    rows.each do |row|
      sql << ", (#{row.join(', ')})"
    end
    [sql]
  end
end

# --

MultiInsert::MultipleQueries.new('a', [[1], [2]]).
  format_sqls
# => [["INSERT INTO a VALUES (1)"],
#     ["INSERT INTO a VALUES (2)"]]

MultiInsert::SingleQuery.new('a', [[1], [2]]).
  format_sqls
# => ["INSERT INTO a VALUES (1), (2)"]

# --

class Adapter
  def multi_insert(table, rows)
    sqls = multi_insert_strategy.
      new(table, rows).
      format_sqls

    sqls.each do |sql|
      execute(sql)
    end
  end
end

# --

class Adapter
  def multi_insert_strategy
    MultiInsert::MultipleQueries
  end
end

# --

class Adapter::P
  def multi_insert_strategy
    MultiInsert::SingleQuery
  end
end
