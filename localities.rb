# bundle exec ruby localities.rb | xclip -selection clipboard

require 'hexagonly'
require 'csv'

localities_csv = CSV.read(File.expand_path('../spec/fixtures/localities.csv', __FILE__))

points = []
localities_csv.first(100).each do |row|
  points << Hexagonly::Point.new(row[2].to_f, row[1].to_f)
end

hexagons = Hexagonly::Hexagon.pack(points, 0.15, { grab_points: true })

# Style features
collected_points = []
hexagons.each do |hex|
  color = "%06x" % (rand * 0xffffff)
  hex.geo_style = { 'fill' => color, 'stroke-width' => 2, 'fill-opacity' => 0.5 }
  collected_points += hex.collected_points.map do |point|
    point.tap do |p|
      p.geo_properties = { 'marker-size' => 'small', 'marker-color' => color, 'marker-symbol' => 'circle' }
    end
  end
end

# Generate GeoJson
geo = Hexagonly::GeoJson.new(hexagons)
geo.add_features(collected_points)

# Output
puts geo.to_json