require_relative 'lib/hexagonal_tiling'

class TestPoly

  include HexagonalTiling::Polygon::Methods
  poly_points_method :custom_poly_points

  attr_reader :custom_poly_points
  def initialize(points)
    @custom_poly_points = points
  end
end

t = TestPoly.new([1, 2, 3])
puts t.custom_poly_points.to_s
puts t.class.poly_points_method_name
puts t.poly_points.to_s