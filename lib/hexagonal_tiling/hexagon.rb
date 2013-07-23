module HexagonalTiling
  class Hexagon

    attr_reader :center, :size, :v_size, :space

    # @param [Number] size the size of the hexagon (width / 2) 
    def initialize(center, size, space = nil)
      @center, @size, @space = center, size, space
      @v_size = @size * Math.cos(30)
    end

    def contains?(point)
      if loosely_contains?(point)
        return HexagonalTiling::Polygon.new(corners).contains?(point)
      end

      false
    end

    # Checks whether the given point lies within the bounding box of the hexagon.
    def loosely_contains?(point)
      ((point.x - @center.x).abs <= @size) && ((point.y - @center.y).abs <= @size)
    end

    # @return [Array<HexagonTiling::Point>] an array of points, coresponding to the 6 corners of the hexagon
    def corners
      corners = []
      (0..5).each do |i|
        angle = 2 * Math::PI / 6 * i
        corner_x = @center.x + @size * Math.cos(angle)
        corner_y = @center.y + @size * Math.sin(angle)
        corners << HexagonalTiling::Point.new(corner_x, corner_y)
      end

      corners
    end

    def to_geojson
      corner_points = corners.map{ |p| [p.x, p.y] }
      corner_points << corner_points.last
      {
        :type => "Feature",
        :geometry => {
          :type => "Polygon",
          :coordinates => [corner_points]
        },
        :properties => nil
      }
    end
    
  end
end