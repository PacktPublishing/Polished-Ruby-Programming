album_infos = 100.times.flat_map do |i|
  10.times.map do |j|
    ["Album #{i}", j, "Track #{j}"]
  end
end

album_artists = album_infos.flat_map(&:last)
album_artists.uniq!
