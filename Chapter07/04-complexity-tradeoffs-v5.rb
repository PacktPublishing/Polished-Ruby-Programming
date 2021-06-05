def _first_n_records(number: (only_one = 1), offset: 0)
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

def first_record(offset: 0, &block)
  _first_n_records(offset: offset, &block)
end

def first_n_records(number, offset: 0, &block)
  _first_n_records(number: number, offset: offset, &block)
end

def first_record(**kwargs, &block)
  kwargs.delete(:number)
  _first_n_records(**kwargs, &block)
end

def first_n_records(number, **kwargs, &block)
  kwargs[:number] = number
  _first_n_records(**kwargs, &block)
end

def first_n_matching_records_starting_at_offset(n, o, &blk)
  _first_n_records(number: n, offset: o, &blk)
end

def first_n_matching_records_starting_at_offset(n, o, &blk)
  raise ArgumentError, "block required" unless blk
  _first_n_records(number: n, offset: o, &blk)
end
