module HexagonalTiling
  class HexagonOld

    attr_reader :radius, :center, :points

    # @param [Float] radius
    # @param [Point] center
    # @param [Space] space the space of points
    # @param [Integer] prev_dir the previous direction of expansion
    def initialize(radius, center, space, prev_dir = nil)
      @radius, @center, @space, @prev_dir = radius, center, space, prev_dir
      @points = nil
      grab
    end

    # Grabs from the space all points contained within the hexagon and removes 
    # those points from the initial space.
    def grab
      @points = @space.points.select{ |p| loosely_contains?(p) }
      @points = @points.select{ |p| contains?(p) }
      @space.remove_points(@points)
    end

    def expand(dir = nil)
      hexagons = []

      case dir
      when :north
        new_center = Point.new(@center.x, @center.y + @radius * 2)
        hex = Hexagon.new(@radius, new_center, @space.north_of(@center), dir)
        hexagons += hex.expand
      when :south
        new_center = Point.new(@center.x, @center.y - @radius * 2)
        hex = Hexagon.new(@radius, new_center, @space.south_of(@center), dir)
        hexagons += hex.expand
      else
        case prev_dir
        when :north
          
        when :south

        when :north_west

        when :north_east

        when :south_west

        when :south_east

        end
      end

      hexagons
    end

    # Checks whether the given point belongs to the hexagon.
    def contains?(point)
      # TODO
    end

    # Checks whether the given point belongs to the bounding box of the hexagon.
    def loosely_contains?(point)
      width_ok = point.x >= (@center.x - @radius) && point.x <= (@center.x + @radius)
      height_ok = point.y >= (@center.y - @radius) && point.y <= (@center.y + @radius)

      width_ok && height_ok
    end

  end
end