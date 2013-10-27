require 'spec_helper'

describe HexagonalTiling::Hexagon do
  
  describe "#hex_corners" do

    context "if hex_center or hex_size have not been defined" do
      subject { HexagonalTiling::Hexagon.new(nil, nil) }
      it { expect { subject.hex_corners }.to raise_error Exception }
    end

    context "if hex_center and hex_size have been defined" do
      subject { HexagonalTiling::Hexagon.new(HexagonalTiling::Point.new(5, 6), 2.1) }
      let(:corners) do 
        [
          [7.1, 6.0], 
          [6.050000000000001, 7.818653347947321], 
          [3.95, 7.818653347947321], 
          [2.9, 6.0], 
          [3.9499999999999993, 4.18134665205268], 
          [6.049999999999999, 4.181346652052678]
        ]
      end
      it { subject.hex_corners.size == 5 }
      it { (subject.hex_corners.map{ |p| [p.x_coord, p.y_coord] } - corners).should == [] }
    end

  end

  describe "#loosely_contains?" do

    context "if hex_center or hex_size have not been defined" do
      subject { HexagonalTiling::Hexagon.new(nil, nil) }
      it { expect { subject.loosely_contains?(HexagonalTiling::Point.new(1, 1)) }.to raise_error Exception }
    end

    context "if hex_center and hex_size have been defined" do
      subject { HexagonalTiling::Hexagon.new(HexagonalTiling::Point.new(5, 6), 2.1) }
      # Outside the bounding box
      it { subject.loosely_contains?(HexagonalTiling::Point.new(5, 8)).should == false }
      it { subject.loosely_contains?(HexagonalTiling::Point.new(5, 4)).should == false }
      it { subject.loosely_contains?(HexagonalTiling::Point.new(2, 6)).should == false }
      it { subject.loosely_contains?(HexagonalTiling::Point.new(8, 6)).should == false }
      # Inside the bounding box but outside the hexagon
      it { subject.loosely_contains?(HexagonalTiling::Point.new(3.3, 7)).should == true }
      it { subject.loosely_contains?(HexagonalTiling::Point.new(6.7, 5)).should == true }
      # Inside the hexagon
      it { subject.loosely_contains?(HexagonalTiling::Point.new(5.1, 6.2)).should == true }
      it { subject.loosely_contains?(HexagonalTiling::Point.new(4.2, 5.3)).should == true }
      it { subject.loosely_contains?(HexagonalTiling::Point.new(5.0, 6.0)).should == true }
    end

  end

  describe "#contains?" do

    context "if hex_center or hex_size have not been defined" do
      subject { HexagonalTiling::Hexagon.new(nil, nil) }
      it { expect { subject.contains?(HexagonalTiling::Point.new(1, 1)) }.to raise_error Exception }
    end

    context "if hex_center and hex_size have been defined" do
      subject { HexagonalTiling::Hexagon.new(HexagonalTiling::Point.new(5, 6), 2.1) }
      # Outside the bounding box
      it { subject.contains?(HexagonalTiling::Point.new(5, 8)).should == false }
      it { subject.contains?(HexagonalTiling::Point.new(5, 4)).should == false }
      it { subject.contains?(HexagonalTiling::Point.new(2, 6)).should == false }
      it { subject.contains?(HexagonalTiling::Point.new(8, 6)).should == false }
      # Inside the bounding box but outside the hexagon
      it { subject.contains?(HexagonalTiling::Point.new(3.3, 7)).should == false }
      it { subject.contains?(HexagonalTiling::Point.new(6.7, 5)).should == false }
      # Inside the hexagon
      it { subject.contains?(HexagonalTiling::Point.new(5.1, 6.2)).should == true }
      it { subject.contains?(HexagonalTiling::Point.new(4.2, 5.3)).should == true }
      it { subject.contains?(HexagonalTiling::Point.new(5.0, 6.0)).should == true }
    end

  end

  describe "#grab" do

    

  end

  describe ".pack_points" do

  end

end