### Designing Useful Custom Classes

## Learning when to create a custom class

stack = []

# add to top of stack
stack.push(1)

# get top value from stack
stack.pop

# --

# add to bottom to stack!
stack.unshift(2)

# --

class Stack
  def initialize
    @stack = []
  end

  def push(value)
    @stack.push(value)
  end

  def pop
    @stack.pop
  end
end

# --

class SymbolStack
  def initialize
    @stack = []
  end

# --

  def push(sym)
    raise TypeError, "can only push symbols onto stack" unless sym.is_a?(Symbol)
    @stack.push([sym, clock_time])
  end

# --

  def pop
    sym, pushed_at = @stack.pop
    [sym, clock_time - pushed_at]
  end

# --

  private def clock_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end

## Handling tradeoffs in SOLID design

str = String.new
str << "test" << "ing...1...2"

name = ARGV[1].
  to_s.
  gsub('cool', 'amazing').
  capitalize

str << ". Found: " << name
puts str

# --

builder = TextBuilder.new
builder.append("test")
builder.append("ing...1...2")

modifier = TextModifier.new
name = modifier.gsub(ARGV[1].to_s, 'cool', 'amazing')
name = modifier.capitalize(name)

builder.append(". Found: ")
builder.append(name)

puts builder.as_string

# --

report = Report.new(data)
puts report.format

# --

report_content = ReportContent.new(data)
report_formatter = ReportFormatter.new
puts report_formatter.format(report_content)

# --

report_content = ReportContent.new(data)
report_formatter = ReportFormatter.
  for_type(report_type).new
puts report_formatter.format(report_content)

# --

class OpenClosed
  def self.meths(m)
    m.instance_methods + m.private_instance_methods
  end

# --

  def self.include(*mods)
    mods.each do |mod|
      unless (meths(mod) & meths(self)).empty?
        raise "class closed for modification"
      end
    end
    super
  end

# --

  singleton_class.alias_method :prepend, :include

# --

  def self.extend(*mods)
    mods.each do |mod|
      unless (meths(mod) & meths(singleton_class)).empty?
        raise "class closed for modification"
      end
    end
    super
  end

# --

  meths(self).each do |method|
    alias_name = :"__#{method}"
    alias_method alias_name, method
  end

# --

  check_method = true
  define_singleton_method(:method_added) do |method|
    return unless check_method

# --

    if method.start_with?('__')
      unaliased_name = method[2..-1]
      if private_method_defined?(unaliased_name) ||
             method_defined?(unaliased_name)
        check_method = false
        alias_method method, unaliased_name
        check_method = true
        raise "class closed for modification"
      end

# --

    else
      alias_name = :"__#{method}"
      if private_method_defined?(alias_name) ||
             method_defined?(alias_name)
        check_method = false
        alias_method method, alias_name
        check_method = true
        raise "class closed for modification"
      end
    end
  end
end

# --

OpenClosed.singleton_class.remove_method(:method_added)

# --

class Max
  def initialize(max)
    @max = max
  end

  def over?(n)
    n > @max
  end
end

# --

class MaxBy < Max
  def over?(n, by)
    n > @max + by
  end
end

# --

class MaxBy < Max
  def over?(n, by: 0)
    n > @max + by
  end
end

# --

if obj.instance_of?(Max)
  # do something
else
  # do something else
end

# --

if obj.class == Max
  # do something
else
  # do something else
end

# --

if obj.kind_of?(Max)
  # do something
else
  # do something else
end

# --

class CurrentDay
  def initialize
    @date = Date.today
    @schedule = MonthlySchedule.new(@date.year,
                                    @date.month)
  end

  def work_hours
    @schedule.work_hours_for(@date)
  end

  def workday?
    !@schedule.holidays.include?(@date)
  end
end

# --

before do
  Date.singleton_class.class_eval do
    alias_method :_today, :today
    define_method(:today){Date.new(2020, 12, 16)}
  end
end

after do
  Date.singleton_class.class_eval do
    alias_method :today, :_today
    remove_method :_today
  end
end

# --

class CurrentDay
  def initialize(date: Date.today)
    @date = date
    @schedule = MonthlySchedule.new(date.year, date.month)
  end
end

# --

class CurrentDay
  def initialize(date: Date.today,
                 schedule: MonthlySchedule.new(date.year,
                                               date.month))
    @date = date
    @schedule = schedule
  end
end

# --

class CurrentDay
  def initialize(date: Date.today,
                 schedule_class: MonthlySchedule)
    @date = date
    @schedule = schedule_class.new(date.year, date.month)
  end
end

## Deciding on larger classes or more classes

require 'cgi/escape'

class HTMLTable
  def initialize(rows)
    @rows = rows
  end

# --

  def to_s
    html = String.new
    html << "<table><tbody>"
    @rows.each do |row|
      html << "<tr>"
      row.each do |cell|
        html << "<td>" << CGI.escapeHTML(cell.to_s) << "</td>"
      end
      html << "</tr>"
    end
    html << "</tbody></table>"
  end
end

# --

class HTMLTable
  class Element
    def self.set_type(type)
      define_method(:type){type}
    end

    def initialize(data)
      @data = data
    end

    def to_s
      "<#{type}>#{@data}</#{type}>"
    end
  end

# --

  %i"table tbody tr td".each do |type|
    klass = Class.new(Element)
    klass.set_type(type)
    const_set(type.capitalize, klass)
  end

# --

  def to_s
    Table.new(
      Tbody.new(
        @rows.map do |row|
          Tr.new(
            row.map do |cell|
              Td.new(CGI.escapeHTML(cell.to_s))
            end.join
          )
        end.join
      )
    ).to_s
  end
end

# --

class HTMLTable
  def wrap(html, type)
    html << "<" << type << ">"
    yield
    html << "</" << type << ">"
  end

# --

  def to_s
    html = String.new
    wrap(html, 'table') do
      wrap(html, 'tbody') do
        @rows.each do |row|
          wrap(html, 'tr') do
            row.each do |cell|
              wrap(html, 'td') do
                html << CGI.escapeHTML(cell.to_s)
              end
            end
          end
        end
      end
    end
  end
end
