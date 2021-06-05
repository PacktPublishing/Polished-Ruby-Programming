def first_record(offset: 0)
  reset
  offset.times{next_record}
  next_record
end

def record_at_offset(o)
  first_record(offset: o)
end

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
