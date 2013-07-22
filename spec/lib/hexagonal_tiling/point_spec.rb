require 'spec_helper'

describe HexagonalTiling::Point do
  
  context "when initialized" do
    it "assigns the given coordinates to readable attributes x and y" do
      p = HexagonalTiling::Point.new(10, 15)
      p.x.should == 10
      p.y.should == 15
    end
  end

end