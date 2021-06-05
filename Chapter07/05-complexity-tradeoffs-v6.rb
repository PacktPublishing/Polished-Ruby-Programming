def first(number: (only_one = 1), offset: 0)
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

first
first(number: 3)
first{|rec| rec.id == 10}
first(number: 9){|rec| rec.name == 'Ruby'}
first(offset: 7)
first(number: 3, offset: 1)
first(offset: 14){|rec| rec.id == 29}
first(number: 7, offset: 4){|rec| rec.name == 'Knight'}
