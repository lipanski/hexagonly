module HexagonalTiling
  class Space

    attr_reader :points, :north, :west, :south, :east, :height, :width, :center

    # @param [Array<Point>] points an array of points that make up the space
    def initialize(points)
      @points = points
      refresh
    end

    def remove_points(points)
      @points -= points
      refresh
    end

    # Builds a new Space object containing all points of the current space
    # that lie north of a given point.
    #
    # @param [HexagonalTiling::Point] point the boundry point for the new space
    # @return [HexagonalTiling::Space]
    def north_of(point)
      Space.new(@points.select{ |p| p.y_coord >= point.y_coord })
    end

    # Builds a new Space object containing all points of the current space
    # that lie west of a given point.
    #
    # @param [HexagonalTiling::Point] point the boundry point for the new space
    # @return [HexagonalTiling::Space]
    def west_of(point)
      Space.new(@points.select{ |p| p.x_coord <= point.x_coord })
    end

    # Builds a new Space object containing all points of the current space
    # that lie south of a given point.
    #
    # @param [HexagonalTiling::Point] point the boundry point for the new space
    # @return [HexagonalTiling::Space]
    def south_of(point)
      Space.new(@points.select{ |p| p.y_coord < point.y_coord })
    end

    # Builds a new Space object containing all points of the current space
    # that lie east of a given point.
    #
    # @param [HexagonalTiling::Point] point the boundry point for the new space
    # @return [HexagonalTiling::Space]
    def east_of(point)
      Space.new(@points.select{ |p| p.x_coord > point.x_coord })
    end

    protected

    def refresh
      compute_boundries
      compute_center
    end

    def compute_boundries
      @north, @west, @south, @east = nil
      @points.each do |p|
        @north = p if @north.nil? || @north.y_coord < p.y_coord
        @west = p if @west.nil? || @west.x_coord > p.x_coord
        @south = p if @south.nil? || @south.y_coord > p.y_coord
        @east = p if @east.nil? || @east.x_coord < p.x_coord
      end
    end

    def compute_center
      compute_boundries if @north.nil? || @west.nil? || @south.nil? || @east.nil?
      @height = @north.y_coord - @south.y_coord
      @width = @east.x_coord - @west.x_coord
      @center = HexagonalTiling::Point.new(@width / 2 + @west.x_coord, @height / 2 + @south.y_coord)
    end

  end
end