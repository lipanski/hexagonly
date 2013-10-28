require 'json'

module Hexagonly
  class GeoJson

    attr_reader :features

    # @param [Array] features an array of objects that support the #to_geojson method
    def initialize(features = nil)
      add_features(features) unless features.nil?
    end

    # Adds features (Points, Spaces, Hexagons) that support the #to_geojson method.
    #
    # @param [Array] features an array of objects that support the #to_geojson method
    def add_features(features)
      @features ||= []
      features.each do |feat|
        @features << feat.to_geojson
      end
    end

    # Outputs the GeoJson string.
    #
    # @return [String] a valid GeoJSON string
    def to_json
      {
        :type => "FeatureCollection",
        :features => @features
      }.to_json
    end

  end
end