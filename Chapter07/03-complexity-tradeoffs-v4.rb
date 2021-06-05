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

alias first_record first_n_records
