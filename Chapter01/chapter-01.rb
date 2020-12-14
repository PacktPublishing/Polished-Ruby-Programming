### Getting the Most out of Core Classes

## When to use core classes

things = ["foo", "bar", "baz"]
things.each do |thing|
  puts thing
end

# --

things = ThingList.new("foo", "bar", "baz")
things.each do |thing|
  puts thing
end

## Best uses for true, false, and nil objects

1.kind_of?(Integer)
# => true

# --

1 > 2
# => false

1 == 1
# => true

# --

[].first
# => nil

{1=>2}[3]
# => nil

# --

!nil
# => true

!1
# => false

# --

"a".gsub!('b', '')
# => nil

[].select!{}
# => nil

{}.reject!{}
# => nil

# --

string = "..."
if string.gsub!('a', 'b')
  # string was modified
end

# --

string.
  gsub!('a', 'b').
  downcase!

# --

@cached_value ||= some_expression
# or
cache[:key] ||= some_expression

# --

if defined?(@cached_value)
  @cached_value
else
  @cached_value = some_expression
end

# --

  cache.fetch(:key){cache[:key] = some_expression}

# --

def nil.foo
  1
end

NilClass.public_instance_methods.include?(:foo)
# => true

## Different numeric types for different needs

10.times do
  # executed 10 times
end

# --

5 / 10
# => 0

7 / 3
# => 2

# --

5 / 10r
# => (1/2)

7.0 / 3
# => 2.3333333333333335

# --

f = 1.1
v = 0.0
1000.times do
  v += f
end
v
# => 1100.0000000000086

# --

f = 1.109375
v = 0.0
1000.times do
  v += f
end
v
# => 1109.375

# --

f = 1.1r
v = 0.0r
1000.times do
  v += f
end
v
# => (1100/1)

# --

f = 1.109375r
v = 0.0r
1000.times do
  v += f
end
v
# => (8875/8)
v.to_f
# => 1109.375

# --

v = BigDecimal(1)/3
v * 3
# => 0.999999999999999999e0

# --

f = BigDecimal(1.1, 2)
v = BigDecimal(0)
1000.times do
  v += f
end
v
# => 0.11e4
v.to_s('F')
# => "1100.0"

# --

f = BigDecimal(1.109375, 7)
v = BigDecimal(0)
1000.times do
  v += f
end
v
# => 0.1109375e4
v.to_s('F')
# => "1109.375"

# --

1.singleton_class
# TypeError (can't define singleton)

# --

1r.singleton_class.class_eval{def meth; end}
# FrozenError

## How symbols differ from strings

foo.add(bar)

# --

method = :add
foo.send(method, bar)

# --

method = "add"
foo.send(method, bar)

# --

object.methods.sort

# --

def switch(value)
  case value
  when :foo
    # foo
  when :bar
    # bar
  when :baz
    # baz
  end
end

# --

def append2(value)
  value.gsub(/foo/, "bar")
end

## How best to use arrays, hashes, and sets

[[:foo, 1], [:bar, 3], [:baz, 7]].each do |sym, i|
  # ...
end

# --

{foo: 1, bar: 3, baz: 7}.each do |sym, i|
  # ...
end

# --

album_artists = {}
album_track_artists = {}
album_infos.each do |album, track, artist|
  (album_artists[album] ||= []) << artist
  (album_track_artists[[album, track]] ||= []) << artist
end
album_artists.each_value(&:uniq!)

# --

lookup = ->(album, track=nil) do
  if track
    album_track_artists[[album, track]]
  else
    album_artists[album]
  end
end

# --

albums = {}
album_infos.each do |album, track, artist|
  ((albums[album] ||= {})[track] ||= []) << artist
end

# --

lookup = ->(album, track=nil) do
  if track
    albums.dig(album, track)
  else
    a = albums[album].each_value.to_a
    a.flatten!
    a.uniq!
    a
  end
end

# --

albums = {}
album_infos.each do |album, track, artist|
  album_array = albums[album] ||= [[]]
  album_array[0] << artist
  (album_array[track] ||= []) << artist
end
albums.each_value do |array|
  array[0].uniq!
end

# --

lookup = ->(album, track=0) do
  albums.dig(album, track)
end

# --

album_artists = album_infos.flat_map(&:last)
album_artists.uniq!

# --

lookup = ->(artists) do
  album_artists & artists
end

# --

album_artists = {}
album_infos.each do |_, _, artist|
  album_artists[artist] ||= true
end

# --

lookup = ->(artists) do
  artists.select do |artist|
    album_artists[artist]
  end
end

# --

album_artists = Set.new(album_infos.flat_map(&:last))

# --

lookup = ->(artists) do
  album_artists & artists
end

## One of the underappreciated core classes, Struct

class Artist
  attr_accessor :name, :albums

  def initialize(name, albums)
    @name = name
    @albums = albums
  end
end

# --

Artist = Struct.new(:name, :albums)

# --

Struct.new(:a, :b).class
# => Class

# --

Struct.new('A', :a, :b).new(1, 2).class
# => Struct::A

# --

def Struct.new(name, *fields)
  unless name.is_a?(String)
    fields.unshift(name)
    name = nil
  end

# --

  subclass = Class.new(self)

  if name
    const_set(name, subclass)
  end

# --

  # Internal magic to setup fields/storage for subclass

  def subclass.new(*values)
    obj = allocate
    obj.initialize(*values)
    obj
  end
  # Similar for allocate, [], members, inspect

  # Internal magic to setup accessor instance methods for each member

  subclass
end

# --

class SubStruct < Struct
end

# --

SubStruct.new('A', :a, :b).new(1, 2).class
# => SubStruct::A

# --

A = Struct.new(:a, :b) do
  def initialize(...)
    super
    freeze
  end
end
