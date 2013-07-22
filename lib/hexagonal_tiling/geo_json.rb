require 'json'

module HexagonalTiling
  class GeoJson

    attr_reader :features

    def initialize(features = nil)
      add_features(features) unless features.nil?
    end

    # Adds features (Points, Spaces, Hexagons) that support the #to_geojson method.
    def add_features(features)
      @features ||= []
      features.each do |feat|
        @features << feat.to_geojson
      end
    end

    # Outputs the GeoJson string.
    def to_json
      {
        :type => "FeatureCollection",
        :features => @features
      }.to_json
    end

  end
end