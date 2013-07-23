module HexagonalTiling
  class Polygon

    attr_reader :points

    # @param [Array<HexagonalTiling::Point>] points the points that make up the polygon
    def initialize(points)
      @points = points
    end

    # Crossing count algorithm for determining whether a point lies within a 
    # polygon or not. Source: http://www.visibone.com/inpoly/
    def contains?(point)
      raise ArgumentError.new("Not a valid polygon!") if @points.size < 3
      is_inside = false
      old_p = @points.last
      @points.each do |new_p|
        if new_p.x > old_p.x
          first_p = old_p
          second_p = new_p
        else
          first_p = new_p
          second_p = old_p
        end
        if ((new_p.x < point.x) == (point.x <= old_p.x)) && ((point.y - first_p.y) * (second_p.x - first_p.x) < (second_p.y - first_p.y) * (point.x - first_p.x))
          is_inside = ! is_inside
        end
        old_p = new_p
      end

      is_inside
    end

  end
end