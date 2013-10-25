module HexagonalTiling
  class Hexagon
    
    module Methods

      include HexagonalTiling::Polygon::Methods
      poly_points_method :hex_corners

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

      end

      attr_accessor :hex_center, :hex_size, :hex_space

      def hex_v_size
        raise "hex_size not defined!" if @hex_size.nil?

        @hex_size * (1.0 - Math.cos(30))
      end

      # Checks whether the given point lies within the hexagon.
      #
      # @return [true|false]
      def contains?(point)
        if loosely_contains?(point)
          super
        end

        false
      end

      # Checks whether the given point lies within the bounding box of the hexagon.
      #
      # @return [true|false]
      def loosely_contains?(point)
        ((point.x_coord - @hex_center.x_coord).abs <= @hex_size) && ((point.y_coord - @hex_center.y_coord).abs <= @hex_size)
      end

      # Returns a hexagon to the north-east with the same radius.
      def north_east_hexagon
        north_east_center = hex_point_class.new(@hex_center.x_coord + @hex_size * 1.5, @hex_center.y_coord + hex_v_size)
        self.class.new(north_east_center, @hex_size, @hex_space)
      end

      # Returns a hexagon to the south-east with the same radius.
      def south_east_hexagon
        south_east_center = hex_point_class.new(@hex_center.x_coord + @hex_size * 1.5, @hex_center.y_coord - hex_v_size)
        self.class.new(south_east_center, @hex_size, @hex_space)
      end

      # Returns a hexagon to the south with the same radius.
      def south_hexagon
        south_center = hex_point_class.new(@hex_center.x_coord, @hex_center.y_coord - hex_v_size * 2.0)
        self.class.new(south_center, @hex_size, @hex_space)
      end

      def to_geojson
        corner_points = hex_corners.map{ |p| [p.x_coord, p.y_coord] }
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

      # Returns an array of the 6 points defining the corners of the hexagon.
      #
      # @return [Array<HexagonTiling::Point>] an array of points, coresponding to 
      #   the 6 corners of the hexagon
      def hex_corners
        corners = []
        (0..5).each do |i|
          angle = 2 * Math::PI / 6 * i
          corner_x = @hex_center.x_coord + @hex_size * Math.cos(angle)
          corner_y = @hex_center.y_coord + @hex_size * Math.sin(angle)
          corners << hex_point_class.new(corner_x, corner_y)
        end

        corners
      end

      private

      def hex_point_class
        @hex_center.nil? ? HexagonalTiling::Model::Point : @hex_center.class
      end

    end

    include Methods

    # @param [Number] size the size of the hexagon (width / 2) 
    def initialize(center, size, space = nil)
      @hex_center, @hex_size, @hex_space = center, size, space
    end

  end
end