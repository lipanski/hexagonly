require 'hexagonal_tiling/version'

require 'hexagonal_tiling/point'
require 'hexagonal_tiling/space'
require 'hexagonal_tiling/polygon'
require 'hexagonal_tiling/hexagon'
require 'hexagonal_tiling/geo_json'
require 'hexagonal_tiling/hexagon_factory'

module HexagonalTiling

  class << self
    
    def pack_points(size, points)
      HexagonalTiling::HexagonFactory.pack_points(size, points)
    end

  end

end
