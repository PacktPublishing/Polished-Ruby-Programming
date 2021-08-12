album_infos = 100.times.flat_map do |i|
  10.times.map do |j|
    ["Album #{i}", j, "Artist #{j}"]
  end
end

album_artists = Set.new(album_infos.flat_map(&:last))

lookup = ->(artists) do
  album_artists & artists
end
