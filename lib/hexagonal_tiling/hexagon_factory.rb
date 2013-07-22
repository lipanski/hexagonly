module HexagonalTiling
  class HexagonFactory

    attr_reader :radius, :points

    def initialize(radius, points)
      @radius, @points, @space = radius, points, HexagonalTiling::Space.new(points)
    end

    def pack_space
      # TODO
    end

  end
end