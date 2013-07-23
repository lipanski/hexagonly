require 'hexagonal_tiling/version'

require 'hexagonal_tiling/point'
require 'hexagonal_tiling/space'
require 'hexagonal_tiling/polygon'
require 'hexagonal_tiling/hexagon'
require 'hexagonal_tiling/geo_json'

module HexagonalTiling

  class << self

    # @param [Float] radius the radius of each hexagon
    # @param [Array<Point>] points an array of Point objects contained in the packing space
    def initialize(radius, points)
      @radius, @points = radius, points
      @north, @west, @south, @east = nil
      @height, @width, @center = nil
      @space = nil
      @hexagons = []
    end

    def pack
      prepare

      center_hex = Hexagon.new(@radius, Point.new(@center.x, @center.y), @space)
      @hexagons = [center_hex]
      @hexagons += center_hex.expand(:north)
      @hexagons += center_hex.expand(:south)

      @hexagons
    end

    private

    def prepare
      compute_boundries
      compute_height_and_width
      compute_center
      setup_space
    end

    def compute_boundries
      @points.each do |p|
        @north = p if @north.nil? || @north.y < p.y
        @west = p if @west.nil? || @west.x > p.x
        @south = p if @south.nil? || @south.y > p.y
        @east = p if @east.nil? || @east.x < p.x
      end
    end

    def compute_height_and_width
      @height = @north.y - @south.y
      @width = @east.x - @west.x
    end

    def compute_center
      compute_boundries if @north.nil? || @west.nil? || @south.nil? || @east.nil?
      compute_height_and_width if @height.nil? || @width.nil?
      center_x = @width / 2 + @west.x
      center_y = @height / 2 + @south.y
      @center = Point.new(center_x, center_y)
    end

    def setup_space
      compute_boundries if @north.nil? || @west.nil? || @south.nil? || @east.nil?
      @space = Space.new(@points, {:north => @north, :west => @west, :south => @south, :east => @east})
    end
    
  end

end
