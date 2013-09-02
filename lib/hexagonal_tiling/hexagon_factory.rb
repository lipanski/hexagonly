module HexagonalTiling
  class HexagonFactory

    attr_reader :size, :points

    def initialize(size, points)
      @size, @points, @space = size, points, HexagonalTiling::Space.new(points)
    end

    def pack_space
      return [] if @points.nil? || @points.empty?

      hexagons = []

      north_west = HexagonalTiling::Point.new(@space.west.x, @space.north.y)

      h_hexagon_count = ((@space.east.x - @space.west.x) / (@size * 2)).ceil.abs
      v_hexagon_count = ((@space.north.y - @space.south.y) / (@size * (1 - Math.cos(30)) * 2)).ceil.abs

      hexagons << hex = HexagonalTiling::Hexagon.new(north_west, @size)
      v_hexagon_count.times do |i|
        first_hex = hex
        h_hexagon_count.times do |j|
          if j % 2 == 0
            hexagons << hex = hex.north_east_hexagon
          else
            hexagons << hex = hex.south_east_hexagon
          end
        end

        hexagons << hex = first_hex.south_hexagon unless i == v_hexagon_count - 1
      end

      hexagons
    end

  end
end