module HexagonalTiling
  class Polygon

    attr_reader :poly_points

    # @param [Array<HexagonalTiling::Point>] poly_points the points that make up the polygon
    def initialize(poly_points)
      @poly_points = poly_points
    end

    # Crossing count algorithm for determining whether a point lies within a 
    # polygon or not. Source: http://www.visibone.com/inpoly/
    def contains?(point)
      raise "Not a valid polygon!" if @poly_points.size < 3
      is_inside = false
      old_p = @poly_points.last
      @poly_points.each do |new_p|
        if new_p.x_coord > old_p.x_coord
          first_p = old_p
          second_p = new_p
        else
          first_p = new_p
          second_p = old_p
        end
        if ((new_p.x_coord < point.x_coord) == (point.x_coord <= old_p.x_coord)) && ((point.y_coord - first_p.y_coord) * (second_p.x_coord - first_p.x_coord) < (second_p.y_coord - first_p.y_coord) * (point.x_coord - first_p.x_coord))
          is_inside = ! is_inside
        end
        old_p = new_p
      end

      is_inside
    end

  end
end