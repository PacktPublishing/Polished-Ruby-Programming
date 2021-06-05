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
