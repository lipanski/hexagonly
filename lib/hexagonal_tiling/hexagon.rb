module HexagonalTiling
  class Hexagon

    attr_reader :center, :h_size, :v_size, :space

    # @param [Number] h_size the horizontal size of the hexagon (width / 2) 
    def initialize(center, h_size, space)
      @center, @h_size, @space = center, h_size, space
      @v_size = @h_size * Math.cos(30)
    end

    def contains?(point)
      q2 = HexagonTiling::Point.new((point.x - @center.x).abs, (point.y - @center.y).abs)

      if q2.x > @h_size * 2 || q2.y > @v_size
        return false
      else
        return @v_size * 2 * @h_size - @v_size * q2.x - 2 * @h_size * q2.y >= 0
      end

      # const q2x:Number = Math.abs(_x – _center.x);
      # const q2y:Number = Math.abs(_y – _center.y);
      # if (q2x > _hori*2 || q2y > _vert) return false;
      # return _vert * 2* _hori – _vert * q2x – 2* _hori * q2y >= 0;
    end

    # @return [Array<HexagonTiling::Point>] an array of points, coresponding to the 6 corners of the hexagon
    def corners
      corners = []
      (0..5).each do |i|
        angle = 2 * Math::PI / 6 * i
        corner_x = @center.x + @h_size * Math.cos(angle)
        corner_y = @center.y + @h_size * Math.sin(angle)
        corners << HexagonTiling::Point.new(x, y)
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
          :coordinates => corner_points
        },
        :properties => {
          "shape" => "hexagon"
        }
      }
    end

    # for (i = 0; i <= 6; i++) {
    #   angle = 2 * PI / 6 * i;
    #   x_i = center_x + size * cos(angle);
    #   y_i = center_y + size * sin(angle);
    #   if (i == 0) {
    #       moveTo(x_i, y_i);
    #   } else {
    #       lineTo(x_i, y_i);
    #   }
    # }
  end
end