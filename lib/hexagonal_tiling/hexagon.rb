module HexagonalTiling
  class Hexagon
    
    # Adds Hexagon methods to an object.
    #
    # @example
    #   class MyHexagon
    #     
    #     include HexagonalTiling::Hexagon::Methods
    #     
    #     def initialize(center, size)
    #       setup_hex(center, size)
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
      
      def self.included(base)
        base.extend(HexagonalTiling::Polygon::ClassMethods)
        base.poly_points_method :hex_corners

        base.extend(ClassMethods)
      end

      module ClassMethods

        # Starting from the north-east corner of the given Points array and going east, 
        # then repeating for every other row to the south, the method generates an 
        # array of hexagons. If params[:grab_points] is true, every hexagon created 
        # on the way grabs all the points contained within.
        #
        # @param points [Array<HexagonalTiling::Point>] the boundries for the generated hexagons
        #   or an Array of points that will be "grabed" by the generated hexagons 
        #   (see @params[:grap_points])
        # @param hex_size [Float] the size of the generated hexagons (width / 2)
        # @param [Hash] params additional parameters
        # @option params [false, true] :grab_points wether to "grab" points - 
        #   stores included points unter hex#collected_points and excluded points
        #   under hex#rejected_points
        # @option params [Class] :hexagon_class the class used to instanciate new hexagons
        #
        # @return [Array<HexagonalTiling::Hexagon] an array of hexagons
        def pack(points, hex_size, params = {})
          return [] if points.nil? || points.empty?

          hexagons = []
          space = HexagonalTiling::Space.new(points)

          h_hexagon_count = ((space.east.x_coord - space.west.x_coord) / (hex_size * 1.5)).abs.ceil
          v_hexagon_count = ((space.north.y_coord - space.south.y_coord) / (hex_size * Math.cos(Math::PI / 6) * 2.0)).abs.ceil + 1

          point_class = points.first.class
          hexagon_class = params.fetch(:hexagon_class, HexagonalTiling::Hexagon)
          grab_points = params.fetch(:grab_points, false)

          north_west = point_class.new.tap{ |p| p.set_coords(space.west.x_coord, space.north.y_coord) }
          hexagons << hex = hexagon_class.new.tap{ |h| h.setup_hex(north_west, hex_size); h.grab(points) if grab_points }
          v_hexagon_count.times do |i|
            first_hex = hex
            h_hexagon_count.times do |j|
              if j % 2 == 0
                hexagons << hex = hex.north_east_hexagon(params)
              else
                hexagons << hex = hex.south_east_hexagon(params)
              end
            end

            hexagons << hex = first_hex.south_hexagon(params) if i < v_hexagon_count - 1
          end

          hexagons
        end

      end

      attr_accessor :hex_center, :hex_size

      # Initializes the hexagon.
      #
      # @param hex_center [HexagonalTiling::Point] the center of the hexagon
      # @param hex_size [Float] the size of the hexagon (horizontal width / 2)
      def setup_hex(hex_center, hex_size)
        @hex_center, @hex_size = hex_center, hex_size
      end

      # The distance from the center of the hexagon to the top / bottom edges.
      #
      # @return [Float]
      def hex_v_size
        raise "hex_size not defined!" if @hex_size.nil?

        @hex_size * Math.cos(Math::PI / 6)
      end

      # Checks whether the given point lies within the hexagon.
      #
      # @return [true|false]
      def contains?(point)
        loosely_contains?(point) ? super : false
      end

      # Checks whether the given point lies within the bounding box of the hexagon.
      #
      # @return [true|false]
      def loosely_contains?(point)
        raise "Call #setup_hex first!" if @hex_center.nil? || @hex_size.nil?
        ((point.x_coord - @hex_center.x_coord).abs <= @hex_size) && ((point.y_coord - @hex_center.y_coord).abs <= hex_v_size)
      end

      # Returns a hexagon to the north-east with the same radius.
      def north_east_hexagon(params = {})
        raise "Call #setup_hex first!" if @hex_center.nil? || @hex_size.nil?

        grab_points = params.fetch(:grab_points, false)

        north_east_center = hex_point_class.new(@hex_center.x_coord + @hex_size * 1.5, @hex_center.y_coord + hex_v_size)
        self.class.new.tap do |hex| 
          hex.setup_hex(north_east_center, @hex_size)
          hex.grab(@rejected_points) if grab_points
        end
      end

      # Returns a hexagon to the south-east with the same radius.
      def south_east_hexagon(params = {})
        raise "Call #setup_hex first!" if @hex_center.nil? || @hex_size.nil?

        grab_points = params.fetch(:grab_points, false)

        south_east_center = hex_point_class.new(@hex_center.x_coord + @hex_size * 1.5, @hex_center.y_coord - hex_v_size)
        self.class.new.tap do |hex| 
          hex.setup_hex(south_east_center, @hex_size)
          hex.grab(@rejected_points) if grab_points
        end
      end

      # Returns a hexagon to the south with the same radius.
      def south_hexagon(params = {})
        raise "Call #setup_hex first!" if @hex_center.nil? || @hex_size.nil?

        grab_points = params.fetch(:grab_points, false)

        south_center = hex_point_class.new(@hex_center.x_coord, @hex_center.y_coord - hex_v_size * 2.0)
        self.class.new.tap do |hex| 
          hex.setup_hex(south_center, @hex_size)
          hex.grab(@rejected_points) if grab_points
        end
      end

      # Returns an array of the 6 points defining the corners of the hexagon.
      #
      # @return [Array<HexagonTiling::Point>] an array of points, coresponding to 
      #   the 6 corners of the hexagon
      def hex_corners
        raise "Call #setup_hex first!" if @hex_center.nil? || @hex_size.nil?
        corners = []
        (0..5).each do |i|
          angle = 2 * Math::PI / 6 * i
          corner_x = @hex_center.x_coord + @hex_size * Math.cos(angle)
          corner_y = @hex_center.y_coord + @hex_size * Math.sin(angle)
          corners << hex_point_class.new(corner_x, corner_y)
        end

        corners
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

      private

      def hex_point_class
        @hex_center.nil? ? HexagonalTiling::Point : @hex_center.class
      end

    end

    include Methods

    # (see #setup_hex)
    def initialize(*params)
      setup_hex(*params) if params.size == 2
    end

  end
end