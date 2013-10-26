module HexagonalTiling
  class Space

    attr_reader :points, :north, :west, :south, :east, :height, :width, :center

    # @param [Array<Point>] points an array of points that make up the space
    def initialize(points)
      @points = points
      refresh
    end
    
    private

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