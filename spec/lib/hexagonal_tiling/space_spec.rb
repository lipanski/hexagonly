require 'spec_helper'

describe HexagonalTiling::Space do

  context "when initialized" do
    before(:each) do
      points_arr = [
        [1, 2], [3, 2], [4, 3], [1, 5], [4, 4], [7, 2], [8, 1], [2, 6], [5, 9], [6, 5], [1, 4]
      ]
      @points = points_arr.map{ |point| HexagonalTiling::Point.new(point[0], point[1]) }
      @space = HexagonalTiling::Space.new(@points)
    end

    it "assigns points to a readable attribute" do
      @space.points.should == @points
    end

    it "computes the boundries for the given space" do
      @space.north.should == HexagonalTiling::Point.new(5, 9)
      @space.west.should == HexagonalTiling::Point.new(1, 2)
      @space.south.should == HexagonalTiling::Point.new(8, 1)
      @space.east.should == HexagonalTiling::Point.new(8, 1)
    end
  end

end