### 7
### Designing Your Library

## Focusing on the user experience

[[1, 2], [3, 4]].to_csv
# => "1,2\n3,4\n"

# --

ToCSV.new([[1, 2], [3, 4]]).csv

# --

ToCSV.csv([[1, 2], [3, 4]])

# --

ToCSV.([[1, 2], [3, 4]])

# --

ToCSV[[[1, 2], [3, 4]]]

## Determining the appropriate size for your library

ToCSV[[[1, 2], [3, 4]]]

# --

def ToCSV.[](enum)
  convertor = AnyToAny.new
  convertor.input_from(enum, type: :enumerable)
  convertor.output_to(:string, type: :csv)
  convertor.run
  convertor.output
end

## Handling complexity trade-offs during method design

def first_record
  reset
  next_record
end

# --

def first_n_records(n)
  reset
  ary = []

  n.times do
    break unless record = next_record
    ary << record
  end

  ary
end

# --

def first_matching_record
  reset

  while record = next_record
    if yield record
      return record
    end
  end

  nil
end

# --

def first_n_matching_records(n)
  reset
  ary = []

  while record = next_record
    if yield record
      ary << record
      break if ary.length >= n
    end
  end

  ary
end

# --

def record_at_offset(o)
  reset
  o.times{next_record}
  next_record
end

# --

def first_n_records_starting_at_offset(n, o)
  reset
  o.times{next_record}
  ary = []

  n.times do
    break unless record = next_record
    ary << record
  end

  ary
end

# --

def first_matching_record_starting_at_offset(o)
  reset
  o.times{next_record}

  while record = next_record
    if yield record
      return record
    end
  end

  nil
end

# --

def first_n_matching_records_starting_at_offset(n, o)
  reset
  o.times{next_record}
  ary = []

  while record = next_record
    if yield record
      ary << record
      break if ary.length >= n
    end
  end

  ary
end

# --

o.times{next_record}

# --

def first_record(offset: 0)
  reset
  offset.times{next_record}
  next_record
end

# --

def record_at_offset(o)
  first_record(offset: o)
end

# --

def first_n_records(n, offset: 0)
  reset
  offset.times{next_record}
  ary = []

  n.times do
    break unless record = next_record
    ary << record
  end

  ary
end

# --

def first_n_records(n, offset: 0)
  reset
  offset.times{next_record}
  ary = []

  while record = next_record
    if !block_given? || yield(record)
      ary << record
      break if ary.length >= n
    end
  end

  ary
end

# --

def first_record(offset: 0)
  reset
  offset.times{next_record}

  while record = next_record
    if !block_given? || yield(record)
      return record
    end
  end

  nil
end

# --

def first_n_records(number: (only_one = 1), offset: 0)
  reset
  offset.times{next_record}
  ary = []

  while record = next_record
    if !block_given? || yield(record)
      ary << record
      break if ary.length >= number
    end
  end

  only_one ? ary[0] : ary
end

# --

alias first_record first_n_records

# --

def first_record(offset: 0, &block)
  _first_n_records(offset: offset, &block)
end

def first_n_records(number, offset: 0, &block)
  _first_n_records(number: number, offset: offset, &block)
end

# --

def first_record(**kwargs, &block)
  kwargs.delete(:number)
  _first_n_records(**kwargs, &block)
end

def first_n_records(number, **kwargs, &block)
  kwargs[:number] = number
  _first_n_records(**kwargs, &block)
end

# --

first
first(number: 3)
first{|rec| rec.id == 10}
first(number: 9){|rec| rec.name == 'Ruby'}
first(offset: 7)
first(number: 3, offset: 1)
first(offset: 14){|rec| rec.id == 29}
first(number: 7, offset: 4){|rec| rec.name == 'Knight'}

# --

def first_n_matching_records_starting_at_offset(n, o, &blk)
  _first_n_records(number: n, offset: o, &blk)
end

# --

def first_n_matching_records_starting_at_offset(n, o, &blk)
  raise ArgumentError, "block required" unless blk
  _first_n_records(number: n, offset: o, &blk)
end
