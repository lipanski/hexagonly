# bundle exec ruby localities.rb | xclip -selection clipboard

require 'hexagonly'
require 'csv'

localities_csv = CSV.read(File.expand_path('../spec/fixtures/localities.csv', __FILE__))

points = []
localities_csv.first(1000).each do |row|
  points << Hexagonly::Point.new(row[2].to_f, row[1].to_f)
end

hexagons = Hexagonly::Hexagon.pack(points, 0.4, { grab_points: true, reject_empty: true })

geo = Hexagonly::GeoJson.new(hexagons)
# geo.add_features(points)
puts geo.to_json