module HexagonalTiling
  class Polygon

    # Adds Polygon methods to an object. The Polygon corners are read via
    # the #poly_points method. You can override this method or use the 
    # #poly_points_method class method to set a method name for reading
    # polygon corners.
    #
    # @example
    #   class MyPolygon
    #     
    #     include HexagonalTiling::Polygon::Methods
    #     poly_points_method :corners
    #     
    #     attr_reader :corners
    #     def initialize(corners); @corners = corners; end
    #     
    #   end
    module Methods

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        attr_accessor :poly_points_method_name

        def poly_points_method(points_method)
          self.poly_points_method_name = points_method.to_sym
        end
      end

      attr_accessor :collected_points, :rejected_points

      def poly_points
        raise NoMethodError if self.class.poly_points_method_name.nil?

        send(self.class.poly_points_method_name)
      end

      # Crossing count algorithm for determining whether a point lies within a 
      # polygon. Ported from http://www.visibone.com/inpoly/inpoly.c.txt
      # (original C code by Bob Stein & Craig Yap).
      def contains?(point)
        raise "Not a valid polygon!" if poly_points.nil? || poly_points.size < 3

        is_inside = false
        old_p = poly_points.last
        poly_points.each do |new_p|
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

      # Grabs all points within the polygon boundries from an array of Points
      # and appends them to @collected_points. All rejected Points are stored 
      # under @rejected_points (if you want to pass the to other objects).
      #
      # @param points [Array<HexagonalTiling::Point>]
      #
      # @return [Array<HexagonalTiling::Point] the grabed points
      def grab(points)
        parts = points.partition{ |p| contains?(p) }
        @collected_points ||= []
        @collected_points += parts[0]
        @rejected_points = parts[1]

        parts[0]
      end

    end

    include Methods

    attr_accessor :poly_points

    # @param [Array<HexagonalTiling::Point>] poly_points the points that make up the polygon
    def initialize(poly_points)
      @poly_points = poly_points
    end

  end
end