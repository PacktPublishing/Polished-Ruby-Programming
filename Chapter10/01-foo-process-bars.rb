Foo.process_bars(
  [:bar1, :baz2, 3, {quux: 1}],
  [:bar2, :baz4, 5],
  # ...
  skip_check: ->(bar){bar.number == 5},
  generate_names: true
)

bar1 = Bar.new(:bar1, :baz2, 3, quux: 1)
bar2 = Bar.new(:bar2, :baz4, 5)

command = ProcessBarCommand.new
command.add_bar(bar1)
command.add_bar(bar2)
# ...
command.skip_check{|bar| bar.number == 5}
command.generate_names = true

Foo.process_bars(command)

Foo.process_bars do |c|
  c.bar(:bar1, :baz2, 3, quux: 1)
  c.bar(:bar2, :baz4, 5)
  # ...
  c.skip_check{|bar| bar.number == 5}
  c.generate_names = true
end

command = ProcessBarCommand.new do |c|
  c.bar(:bar1, :baz2, 3, quux: 1)
  c.bar(:bar2, :baz4, 5)
  # ...
  c.skip_check{|bar| bar.number == 5}
  c.generate_names = true
end

Foo.process_bars(command)

class ProcessBarDSL
  def initialize(command)
    @command = command
  end

  def bar(...)
    @command.add_bar(...)
  end

  def method_missing(...)
    @command.send(...)
  end
end

def Foo.process_bars
  command = ProcessBarCommand.new
  yield ProcessBarDSL.new(command)

  handle_bar_processing(command)
end
