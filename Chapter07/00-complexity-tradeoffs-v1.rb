def first_record
  reset
  next_record
end

def first_n_records(n)
  reset
  ary = []

  n.times do
    break unless record = next_record
    ary << record
  end

  ary
end

def first_matching_record
  reset

  while record = next_record
    if yield record
      return record
    end
  end

  nil
end

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

def record_at_offset(o)
  reset
  o.times{next_record}
  next_record
end

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
