module HexagonalTiling
  class Space

    attr_reader :points, :north, :west, :south, :east

    # @param [Array<Point>] points an array of points that make up the space
    def initialize(points)
      @points = points
      compute_boundries
    end

    def remove_points(points)
      @points -= points
    end

    def north_of(point)
      Space.new(@points.select{ |p| p.y >= point.y })
    end

    def west_of(point)
      Space.new(@points.select{ |p| p.x <= point.x })
    end

    def south_of(point)
      Space.new(@points.select{ |p| p.y < point.y })
    end

    def east_of(point)
      Space.new(@points.select{ |p| p.x > point.x })
    end

    private

    def compute_boundries
      @points.each do |p|
        @north = p if @north.nil? || @north.y < p.y
        @west = p if @west.nil? || @west.x > p.x
        @south = p if @south.nil? || @south.y > p.y
        @east = p if @east.nil? || @east.x < p.x
      end
    end

  end
end