require 'spec_helper'

describe HexagonalTiling::Space do

  context "when initialized with sufficient points" do
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

    it "computes the boundries of this space" do
      @space.north.should == HexagonalTiling::Point.new(5, 9)
      @space.west.should == HexagonalTiling::Point.new(1, 2)
      @space.south.should == HexagonalTiling::Point.new(8, 1)
      @space.east.should == HexagonalTiling::Point.new(8, 1)
    end

    it "computes the center of this space" do
      @space.center.class.should == HexagonalTiling::Point
      @space.center.should == HexagonalTiling::Point.new((8 - 1) / 2 + 1, (9 - 1) / 2 + 1)
    end
  end

end