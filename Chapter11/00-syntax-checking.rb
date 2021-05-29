Dir['/path/to/dir/**/*.rb'].each do |file|
  print file, ': '
  system('ruby', '-c', '--disable-gems', file)
end

Dir['/path/to/dir/**/*.rb'].each do |file|
  read, write = IO.pipe
  print '.'
  system('ruby', '-c', '--disable-gems', file,
         out: write, err: write)
  write.close
  output = read.read
  unless output.chomp == "Syntax OK"
    puts
    puts output
  end
end

Dir['/path/to/dir/**/*.rb'].each do |file|
  read, write = IO.pipe
  print '.'
  system('ruby', '-wc', '--disable-gems', file,
         out: write, err: write)
  write.close
  output = read.read
  unless output.chomp == "Syntax OK"
    puts
    puts output.sub(/Syntax OK\Z/, '')
  end
end
