module HexagonalTiling
  class Hexagon
    
    # Adds Hexagon methods to an object.
    #
    # @example
    #   class MyHexagon
    #     
    #     include HexagonalTiling::Hexagon::Methods
    #     
    #     def initialize(center, size, space)
    #       setup_hex(center, size, space)
    #     end
    #     
    #   end
    #
    #   hex = MyHexagon.new(HexagonalTiling::Point.new(1, 2), 0.5)
    #   hex.hex_corners # => an array containing all 6 corners of the hexagon
    #   hex.contains?(HexagonalTiling::Point.new(1, 2)) # => true
    #   hex.contains?(HexagonalTiling::Point.new(3, 3)) # => false
    module Methods

      include HexagonalTiling::Polygon::Methods
      poly_points_method :hex_corners

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        # Starting from the north-east corner of the given Points array and going east, 
        # then repeating for every other row to the south, the method generates an 
        # array of hexagons. Every hexagon created on the way grabs all the points
        # contained within.
        #
        # @param points [Array<HexagonalTiling::Point>]
        # @param hex_size [Integer] the size of the hexagon (width / 2)
        #
        # @return [Array<HexagonalTiling::Hexagon] an array of hexagons
        #
        # @throws ArgumentError in case size is not an Integer
        def pack_points(points, hex_size)
          return [] if points.nil? || points.empty?

          hexagons = []
          hex_size = Integer(hex_size)
          space = HexagonalTiling::Space.new(points)

          h_hexagon_count = ((space.east.x_coord - space.west.x_coord) / (hex_size * 1.5)).abs.ceil
          v_hexagon_count = ((space.north.y_coord - space.south.y_coord) / (hex_size * (1.0 - Math.cos(30)) * 2.0)).abs.ceil + 1

          point_class = points.first.class
          hexagon_class = self.class

          north_west = point_class.new.tap{ |p| p.set_coords(space.west.x_coord, space.north.y_coord) }
          hexagons << hex = hexagon_class.new.tap{ |h| h.setup_hex(north_west, hex_size); h.grab(points) }
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

      attr_accessor :hex_center, :hex_size, :hex_points, :hex_rejected_points

      def setup_hex(hex_center, hex_size)
        @hex_center, @hex_size = hex_center, hex_size
      end

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

      # Grabs all points within the hexagon boundries from an array of Points
      # and appends them to @hex_points. All rejected Points are stored under
      # @hex_rejected_points.
      #
      # @param points [Array<HexagonalTiling::Point>]
      #
      # @return [Array<HexagonalTiling::Point] the grabed points
      def grab(points)
        parts = points.partition{ |p| contains?(p) }
        @hex_points ||= []
        @hex_points += parts[0]
        @hex_rejected_points = parts[1]

        parts[0]
      end

      # Returns a hexagon to the north-east with the same radius.
      def north_east_hexagon
        north_east_center = hex_point_class.new(@hex_center.x_coord + @hex_size * 1.5, @hex_center.y_coord + hex_v_size)
        self.class.new.tap{ |hex| hex.setup_hex(north_east_center, @hex_size); hex.grab(@hex_rejected_points) }
      end

      # Returns a hexagon to the south-east with the same radius.
      def south_east_hexagon
        south_east_center = hex_point_class.new(@hex_center.x_coord + @hex_size * 1.5, @hex_center.y_coord - hex_v_size)
        self.class.new.tap{ |hex| hex.setup_hex(south_east_center, @hex_size); hex.grab(@hex_rejected_points) }
      end

      # Returns a hexagon to the south with the same radius.
      def south_hexagon
        south_center = hex_point_class.new(@hex_center.x_coord, @hex_center.y_coord - hex_v_size * 2.0)
        self.class.new.tap{ |hex| hex.setup_hex(south_center, @hex_size); hex.grab(@hex_rejected_points) }
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
        @hex_center.nil? ? HexagonalTiling::Point : @hex_center.class
      end

    end

    include Methods

    # @param [Number] hex_size the size of the hexagon (width / 2) 
    def initialize(hex_center, hex_size)
      setup_hex(hex_center, hex_size)
    end

  end
end