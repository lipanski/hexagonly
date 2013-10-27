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

      def poly_points
        raise NoMethodError if self.class.poly_points_method_name.nil?
        send(self.class.poly_points_method_name)
      end

      # Crossing count algorithm for determining whether a point lies within a 
      # polygon or not. Source: http://www.visibone.com/inpoly/
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

    end

    include Methods

    attr_accessor :poly_points

    # @param [Array<HexagonalTiling::Point>] poly_points the points that make up the polygon
    def initialize(poly_points)
      @poly_points = poly_points
    end

  end
end