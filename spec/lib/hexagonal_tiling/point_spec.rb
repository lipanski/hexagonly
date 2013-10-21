require 'spec_helper'
require 'factories'

describe HexagonalTiling::Point do
  
  context "when initialized" do
    it "assigns the given coordinates to readable attributes x and y" do
      p = HexagonalTiling::Point.new(10, 15)
      p.x_coord.should == 10
      p.y_coord.should == 15
    end
  end

  context "test factory_girl" do
    it "raises error" do
      points = build_list(:point, 20)
      geo = HexagonalTiling::GeoJson.new(points)
      puts geo.to_json
    end
  end

end