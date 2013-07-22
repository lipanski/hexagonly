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

    context "when calling #remove_points" do
      before(:each) do
        @removed_points = @space.points.first(3)
        @space.remove_points(@removed_points)
      end

      it "removes the given points from the space" do
        @space.points.should == @points - @removed_points
      end

      it "computes the boundries again" do
        @space.north.should == HexagonalTiling::Point.new(5, 9)
        @space.west.should == HexagonalTiling::Point.new(1, 5)
        @space.south.should == HexagonalTiling::Point.new(8, 1)
        @space.east.should == HexagonalTiling::Point.new(8, 1)
      end
    end

    context "when calling #north_of" do
      before(:each) do
        @north_point = HexagonalTiling::Point.new(4, 5)
        @north_space = @space.north_of(@north_point)
      end

      it "returns a new space containing all points having y >= the given point" do
        @north_space.class.should == HexagonalTiling::Space
        @north_space.points.should == [ [1, 5], [2, 6], [5, 9], [6, 5] ].map{ |point| HexagonalTiling::Point.new(point[0], point[1]) }
      end
    end

    context "when calling #west_of" do
      before(:each) do
        @west_point = HexagonalTiling::Point.new(4, 5)
        @west_space = @space.west_of(@west_point)
      end

      it "returns a new space containing all points having x <= the given point" do
        @west_space.class.should == HexagonalTiling::Space
        @west_space.points.should == [ [1, 2], [3, 2], [4, 3], [1, 5], [4, 4], [2, 6], [1, 4] ].map{ |point| HexagonalTiling::Point.new(point[0], point[1]) }
      end
    end

    context "when calling #south_of" do
      before(:each) do
        @south_point = HexagonalTiling::Point.new(4, 5)
        @south_space = @space.south_of(@south_point)
      end

      it "returns a new space containing all points having y < the given point" do
        @south_space.class.should == HexagonalTiling::Space
        @south_space.points.should == [ [1, 2], [3, 2], [4, 3], [4, 4], [7, 2], [8, 1], [1, 4] ].map{ |point| HexagonalTiling::Point.new(point[0], point[1]) }
      end
    end

    context "when calling #east_of" do
      before(:each) do
        @east_point = HexagonalTiling::Point.new(4, 5)
        @east_space = @space.east_of(@east_point)
      end

      it "returns a new space containing all points having x > the given point" do
        @east_space.class.should == HexagonalTiling::Space
        @east_space.points.should == [ [7, 2], [8, 1], [5, 9], [6, 5] ].map{ |point| HexagonalTiling::Point.new(point[0], point[1]) }
      end
    end
  end

end