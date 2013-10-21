module HexagonalTiling
  module HasCoordinates

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :x_coord_name, :y_coord_name

      def set_x_coord_name(x_coord_name)
        self.x_coord_name = x_coord_name.to_sym
      end

      def set_y_coord_name(y_coord_name)
        self.y_coord_name = y_coord_name.to_sym
      end

      def set_coord_names(x_coord_name, y_coord_name)
        set_x_coord_name(x_coord_name)
        set_y_coord_name(y_coord_name)
      end
    end

    def x_coord
      send(self.class.x_coord_name || :x)
    end

    def y_coord
      send(self.class.y_coord_name || :y)
    end

    include Comparable

    def <=>(another_point)
      if x_coord == another_point.x_coord && y_coord == another_point.y_coord
        0
      elsif x_coord > another_point.x_coord
        1
      else
        -1
      end
    end

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
end