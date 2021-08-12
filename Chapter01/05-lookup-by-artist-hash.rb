album_infos = 100.times.flat_map do |i|
  10.times.map do |j|
    ["Album #{i}", j, "Artist #{j}"]
  end
end

album_artists = {}
album_infos.each do |_, _, artist|
  album_artists[artist] ||= true
end

lookup = ->(artists) do
  artists.select do |artist|
    album_artists[artist]
  end
end
