module HexagonalTiling
  class Point

    include HasCoordinates
    set_coord_names :x, :y

    attr_reader :x, :y

    def initialize(x, y)
      @x, @y = x, y
    end

  end
end