module HexagonalTiling
  class HexagonFactory

    attr_reader :size, :points

    def initialize(size, points)
      @size, @points, @space = size, points, HexagonalTiling::Space.new(points)
    end

    # Starting from the north-east corner of the given space and going east, 
    # then repeating for every other row to the south, the method generates an 
    # array of hexagons. Every hexagon created on the way grabs all the points
    # contained within.
    #
    # @return [Array<HexagonalTiling::Hexagon] an array of hexagons
    def pack_space
      return [] if @points.nil? || @points.empty?

      hexagons = []

      h_hexagon_count = ((@space.east.x_coord - @space.west.x_coord) / (@size * 1.5)).abs.ceil
      v_hexagon_count = ((@space.north.y_coord - @space.south.y_coord) / (@size * (1.0 - Math.cos(30)) * 2.0)).abs.ceil + 1

      north_west = HexagonalTiling::Point.new(@space.west.x_coord, @space.north.y_coord)
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

        hexagons << hex = first_hex.south_hexagon if i < v_hexagon_count - 1
      end

      hexagons
    end

    class << self

      # Starting from the north-east corner of the given space and going east, 
      # then repeating for every other row to the south, the method generates an 
      # array of hexagons. Every hexagon created on the way grabs all the points
      # contained within.
      #
      # @return [Array<HexagonalTiling::Hexagon] an array of hexagons
      #
      # @throws ArgumentError in case size is not an Integer
      def pack_points(size, points)
        size = Integer(size)
        space = HexagonalTiling::Space.new(points)

        return [] if points.nil? || points.empty?

        hexagons = []

        h_hexagon_count = ((space.east.x_coord - space.west.x_coord) / (size * 1.5)).abs.ceil
        v_hexagon_count = ((space.north.y_coord - space.south.y_coord) / (size * (1.0 - Math.cos(30)) * 2.0)).abs.ceil + 1

        north_west = HexagonalTiling::Point.new(space.west.x_coord, space.north.y_coord)
        hexagons << hex = HexagonalTiling::Hexagon.new(north_west, size)
        v_hexagon_count.times do |i|
          first_hex = hex
          h_hexagon_count.times do |j|
            if j % 2 == 0
              hexagons << hex = hex.north_east_hexagon
            else
              hexagons << hex = hex.south_east_hexagon
            end
          end

          hexagons << hex = first_hex.south_hexagon if i < v_hexagon_count - 1
        end

        hexagons
      end

    end

  end
end