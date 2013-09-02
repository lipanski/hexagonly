module HexagonalTiling
  class Hexagon < Polygon

    attr_reader :center, :size, :v_size, :space

    # @param [Number] size the size of the hexagon (width / 2) 
    def initialize(center, size, space = nil)
      @center, @size, @space = center, size, space
      @v_size = @size * (1 - Math.cos(30))
      super(corners)
    end

    def contains?(point)
      if loosely_contains?(point)
        super
      end

      false
    end

    # Checks whether the given point lies within the bounding box of the hexagon.
    def loosely_contains?(point)
      ((point.x - @center.x).abs <= @size) && ((point.y - @center.y).abs <= @size)
    end

    # Returns the hexagon to the north-east with the same radius.
    def north_east_hexagon
      north_east_center = HexagonalTiling::Point.new(@center.x + @size * 1.5, @center.y + @v_size)
      HexagonalTiling::Hexagon.new(north_east_center, @size, @space)
    end

    # Returns the hexagon to the south-east with the same radius.
    def south_east_hexagon
      south_east_center = HexagonalTiling::Point.new(@center.x + @size * 1.5, @center.y - @v_size)
      HexagonalTiling::Hexagon.new(south_east_center, @size, @space)
    end

    # Returns the hexagon to the south with the same radius.
    def south_hexagon
      south_center = HexagonalTiling::Point.new(@center.x, @center.y - @v_size * 2)
      HexagonalTiling::Hexagon.new(south_center, @size, @space)
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

    protected

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
    
  end
end