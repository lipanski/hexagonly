# bundle exec ruby localities.rb | xclip -selection clipboard

require 'hexagonal_tiling'
require 'csv'

localities_csv = CSV.read(File.expand_path('../spec/fixtures/localities.csv', __FILE__))

points = []
localities_csv.first(100).each do |row|
  points << HexagonalTiling::Point.new(row[2].to_f, row[1].to_f)
end

hexagons = HexagonalTiling::HexagonFactory.pack_space(0.15, points)

geo = HexagonalTiling::GeoJson.new(hexagons)
geo.add_features(points)
puts geo.to_json