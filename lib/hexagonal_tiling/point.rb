module HexagonalTiling
  class Point

    # Adds Point methods to an object. Any Point bears x and y coordinates,
    # returned by the #x and #y methods. You can either override these methods
    # to output your desired coordinates or you can map coordinate readers to 
    # different method names by using the #x_y_coord_methods, #x_coord_method or 
    # #y_coord_method methods.
    #
    # @example
    #   class MyPoint
    #     
    #     include HexagonalTiling::Point::Methods
    #     # The x coordinate will be read from #a and the y coordinate will be read from #b
    #     x_y_coord_methods :a, :b
    #     
    #     attr_accessor :a, :b
    #     def initialize(a, b); @a, @b = a, b; end
    #     
    #   end
    #   
    #   p = MyPoint.new(1, 2)
    #   p.x_coord # => 1
    #   p.y_coord # => 2
    module Methods

      include Comparable

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        attr_accessor :x_coord_method_name, :y_coord_method_name

        def x_coord_method(x_method)
          self.x_coord_method_name = x_method.to_sym
        end

        def y_coord_method(y_method)
          self.y_coord_method_name = y_method.to_sym
        end

        def x_y_coord_methods(x_method, y_method)
          x_coord_method(x_method)
          y_coord_method(y_method)
        end
      end

      def x_coord
        send(self.class.x_coord_method_name || 'x')
      end

      def x_coord=(value)
        send("#{self.class.x_coord_method_name || 'x'}=", value)
      end

      def y_coord
        send(self.class.y_coord_method_name || 'y')
      end

      def y_coord=(value)
        send("#{self.class.y_coord_method_name || 'y'}=", value)
      end

      # Sets the coordinates for the current Point.
      #
      # @param x [Float]
      # @param y [Float]
      def set_coords(x, y)
        self.x_coord = x
        self.y_coord = y
      end

      def <=>(another_point)
        if x_coord == another_point.x_coord && y_coord == another_point.y_coord
          0
        elsif x_coord > another_point.x_coord
          1
        else
          -1
        end
      end

      # Enable implicit splat.
      # def to_ary
      #   [x_coord, y_coord]
      # end

      def to_geojson
        {
          :type => "Feature",
          :geometry => {
            :type => "Point",
            :coordinates => [x_coord, y_coord]
          },
          :properties => nil
        }
      end

    end

  include Methods

  attr_accessor :x, :y
  
  # (see #set_coords)
  def initialize(*coords)
    set_coords(*coords) if coords.size == 2
  end

  end
end