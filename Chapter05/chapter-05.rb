### 5
### Handling Errors

## Handling errors with return values

# Python code:
{'a': 2}['b']
# KeyError: 'b'

# --

{'a'=>2}['b']
# => nil

# --

# Python code:
{'a': 2}.get('b', None)
# => None (Python equivalent of Ruby's nil)

# --

{'a'=>2}.fetch('b')
# KeyError (key not found: "b")

# --

hash[key] ||= value

# --

hash[key] || (hash[key] = value)

# --

if hash.key?(key)
  hash[key]
else
  hash[key] = value
end

# --

ary = [1, 2, 3]
ary[3]
# => nil

ary << 4
ary[3]
# => 4

# --

hash = {1 => 2}
hash[3]
# => nil

hash[3] = 4
hash[3]
# => 4

# --

require 'ostruct'

os = OpenStruct.new
os[:b]
# => nil

os.b = 1
os[:b]
# => 1

# --

A = Struct.new(:a)
a = A.new(1)
a[:a]
# => 1

a[:b]
# NameError (no member 'b' in struct)

# --

def pk_lookup(pk)
  database.first(<<-END)
    SELECT * FROM table where id = #{database.literal(pk)}
  END
end

# --

def pk_lookup(pk)
  return unless pk
  database.first(<<-END)
    SELECT * FROM table where id = #{database.literal(pk)}
  END
end

# --

def update(pk, column, value)
  database.run_update(<<-SQL)
    UPDATE table
    SET #{column} = #{database.literal(value)}
    WHERE id = #{database.literal(pk)}
  SQL
end

# --

update(self.id, :name, 'New Name')

## Handling errors with exceptions

"S".length(1)
# ArgumentError (wrong number of arguments)

# --

'S'.count(1)
# TypeError (no implicit conversion of Integer into String)

# --

class Authorizer
  def self.check(user, action)
    new(user, action).authorized?
  end

  def authorized?
    return true if user.admin?
    return true if action == :view_own_profile
    false
  end
end

# --

if Authorizer.check(current_user, :manage_users)
  show_manage_users_page
else
  show_invalid_access_page
end

# --

Authorizer.check(current_user, :manage_users)
show_manage_users_page

# --

class Authorizer
  class InvalidAuthorization < StandardError
  end

  def self.check(user, action)
    unless new(user, action).authorized?
      raise InvalidAuthorization,
      "#{user.name} is not authorized to perform #{action}"
    end
  end
end

# --

if Authorizer.check(current_user, :manage_users)
  show_manage_users_page
else
  show_invalid_access_page
end

# --

begin
  Authorizer.check(current_user, :manage_users)
rescue Authorizer::InvalidAuthorization
  # don't show link
else
  display_manage_users_link
end

# --

class Authorizer
  def self.allowed?(user, action)
    new(user, action).authorized?
  end
end

# --

if Authorizer.allowed?(current_user, :manage_users)
  show_manage_users_page
else
  show_invalid_access_page
end

# --

code:Authorizer.check(current_user, :manage_users)
show_manage_users_page

# --

begin
  handle_request
rescue Authorizer::InvalidAuthorization
  show_invalid_access_page
end

# --

raise ArgumentError, "message"

# --

raise ArgumentError, "message", []

# --

# Earlier, outside the method
EMPTY_ARRAY = [].freeze

# Later, inside a method
raise ArgumentError, "message", EMPTY_ARRAY

# --

exception = ArgumentError.new("message")
raise exception

# --

exception = ArgumentError.new("message")
exception.set_backtrace(EMPTY_ARRAY)
raise exception

# --

exception = ArgumentError.new("message")
if LibraryModule.skip_exception_backtraces
  exception.set_backtrace(EMPTY_ARRAY)
end
raise exception

## Retrying transient errors

nil.to_s(16)

# --

require 'net/http'
require 'uri'

Net::HTTP.get_response(URI("http://example.local/file"))

# --

require 'net/http'
require 'uri'

begin
  Net::HTTP.get_response(URI("http://example.local/file"))
rescue
  retry
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")
begin
  Net::HTTP.get_response(uri)
rescue SocketError, SystemCallError, Net::HTTPBadResponse
  retry
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")
begin
  response = Net::HTTP.get_response(uri)
  if response.code.to_i >= 400
    # retry # would be nice
  end
rescue SocketError, SystemCallError, Net::HTTPBadResponse
  retry
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")
begin
  response = Net::HTTP.get_response(uri)
  if response.code.to_i >= 400
    raise Net::HTTPBadResponse
  end
rescue SocketError, SystemCallError, Net::HTTPBadResponse
  retry
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")

while response = Net::HTTP.get_response(uri)
  break unless response.code.to_i >= 400
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")

response = nil
1.times do
  response = Net::HTTP.get_response(uri)

  if response.code.to_i >= 400
    redo
  end
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")

retries = 0
begin
  Net::HTTP.get_response(uri)
rescue SocketError, SystemCallError, Net::HTTPBadResponse
  retries += 1
  raise if retries > 3
  retry
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")

response = nil
4.times do
  response = Net::HTTP.get_response(uri)

  break if response.code.to_i < 400
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")

retries = 0
begin
  Net::HTTP.get_response(uri)
rescue SocketError, SystemCallError, Net::HTTPBadResponse
  retries += 1
  raise if retries > 3
  sleep(3)
  retry
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")

retries = 0
begin
  Net::HTTP.get_response(uri)
rescue SocketError, SystemCallError, Net::HTTPBadResponse
  retries += 1
  raise if retries > 3
  sleep(3 * 2**(retries-1))
  retry
end

# --

require 'net/http'
require 'uri'

uri = URI("http://example.local/file")

retries = 0
begin
  Net::HTTP.get_response(uri)
rescue SocketError, SystemCallError, Net::HTTPBadResponse
  retries += 1
  raise if retries > 3
  sleep(3 * (0.5 + rand/2) * 1.5**(retries-1))
  retry
end

# --

begin
  @recommendations = recommender_service.call(timeout: 3)
rescue
end
@ads = ad_service.call(timeout: 3) rescue nil
process_payment

# --

class BrokenCircuit
  def initialize(num_failures: 3, within: 60)
    @num_failures = num_failures
    @within = within
    @failures = []
  end

# --

  def check
    if @failures.length >= @num_failures
      cutoff = Time.now - @within
      @failures.reject!{|t| t < cutoff}
      return if @failures.length >= @num_failures
    end

    begin
      yield
    rescue
      @failures << Time.now
      nil
    end
  end
end

# --

RECOMMENDER_CIRCUIT = BrokenCircuit.new
AD_CIRCUIT = BrokenCircuit.new

# --

@recommendations = RECOMMENDER_CIRCUIT.check do
  recommender_service.call(timeout: 3)
end
@ads = AD_CIRCUIT.check do
  ad_service.call(timeout: 3)
end
process_payment

## Designing exception class hierarchies

def foo(bar)
  unless allowed?(bar)
    raise "bad bar: #{bar.inspect}"
  end
end

# --

module Foo
  class Error < StandardError
  end

  def foo(bar)
    unless allowed?(bar)
      raise Error, "bad bar: #{bar.inspect}"
    end
  end
end

# --

module Foo
  class Error < StandardError
  end
  class TransientError < Error
  end
end

# --

begin
  foo(bar)
rescue Foo::TransientError
  sleep(3)
  retry
end

# --

begin
  foo(bar)
rescue Foo::Error => e
  if e.message =~ /\Abad bar: /
    handle_bad_bar(bar)
  else
    raise
  end
end

# --

module Foo
  class Error < StandardError
  end
  class TransientError < Error
  end
  class BarError < Error
  end

  def foo(bar)
    unless allowed?(bar)
      raise BarError, "bad bar: #{bar.inspect}"
    end
  end
end

# --

begin
  foo(bar)
rescue Foo::BarError
  handle_bad_bar(bar)
end

# --

def baz(int)
  unless int.is_a?(Integer)
    raise(TypeError,
          "int should be an Integer, is #{int.class}")
  end
  int + 10
end

# --

def baz(int)
  10 + int
end
