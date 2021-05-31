before '/foos/(create|bazs)' do
  check_access
end

before '/foos/:x' do |segment|
  case segment
  when 'index', 'bars'
  else
   check_access
  end
end
