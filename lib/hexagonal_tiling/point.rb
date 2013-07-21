module HexagonalTiling
  class Point

    attr_reader :x, :y

    include Comparable

    # @param [Float] x the x-axis / longitude coordinate of the point
    # @param [Float] y the y-axis / latitude coordinate of the point
    def initialize(x, y)
      @x, @y = x, y
    end

    def <=>(another_point)
      if @x == another_point.x && @y == another_point.y
        0
      elsif @x > another_point.x
        1
      else
        -1
      end
    end

  end
end