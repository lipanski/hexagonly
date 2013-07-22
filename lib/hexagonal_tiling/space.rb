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

    def refresh
      compute_boundries
      compute_center
    end

    def compute_boundries
      @north, @west, @south, @east = nil
      @points.each do |p|
        @north = p if @north.nil? || @north.y < p.y
        @west = p if @west.nil? || @west.x > p.x
        @south = p if @south.nil? || @south.y > p.y
        @east = p if @east.nil? || @east.x < p.x
      end
    end

    def compute_center
      compute_boundries if @north.nil? || @west.nil? || @south.nil? || @east.nil?
      @height = @north.y - @south.y
      @width = @east.x - @west.x
      @center = HexagonalTiling::Point.new(@width / 2 + @west.x, @height / 2 + @south.y)
    end

  end
end