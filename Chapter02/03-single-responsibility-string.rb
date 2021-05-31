str = String.new
str << "test" << "ing...1...2"

name = ARGV[1].
  to_s.
  gsub('cool', 'amazing').
  capitalize

str << ". Found: " << name
puts str
