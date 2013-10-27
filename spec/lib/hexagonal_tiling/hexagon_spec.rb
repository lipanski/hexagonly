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

    context "when none of the points belong to the hexagon" do
      let(:rejected_points) { [[5, 8], [5, 4], [2, 6], [8, 6], [3.3, 7], [6.7, 5]].map{ |x, y| HexagonalTiling::Point.new(x, y) } }
      subject do
        hex = HexagonalTiling::Hexagon.new(HexagonalTiling::Point.new(5, 6), 2.1)
        hex.grab(rejected_points)
        hex
      end
      it { subject.collected_points.class.should == Array }
      it { subject.collected_points.size.should == 0 }
      it { subject.rejected_points.class.should == Array }
      it { subject.rejected_points.should == rejected_points }
    end

    context "when some of the points belong to the hexagon" do
      let(:accepted_points) { [[5.1, 6.2], [4.2, 5.3], [5.0, 6.0]].map{ |x, y| HexagonalTiling::Point.new(x, y) } }
      let(:rejected_points) { [[5, 8], [5, 4], [2, 6], [8, 6], [3.3, 7], [6.7, 5]].map{ |x, y| HexagonalTiling::Point.new(x, y) } }
      subject do
        hex = HexagonalTiling::Hexagon.new(HexagonalTiling::Point.new(5, 6), 2.1)
        hex.grab(accepted_points + rejected_points)
        hex
      end
      it { subject.collected_points.class.should == Array }
      it { subject.collected_points.should == accepted_points }
      it { subject.rejected_points.class.should == Array }
      it { subject.rejected_points.should == rejected_points }
    end

    context "when all of the points belong to the hexagon" do
      let(:accepted_points) { [[5.1, 6.2], [4.2, 5.3], [5.0, 6.0]].map{ |x, y| HexagonalTiling::Point.new(x, y) } }
      subject do
        hex = HexagonalTiling::Hexagon.new(HexagonalTiling::Point.new(5, 6), 2.1)
        hex.grab(accepted_points)
        hex
      end
      it { subject.collected_points.class.should == Array }
      it { subject.collected_points.should == accepted_points }
      it { subject.rejected_points.class.should == Array }
      it { subject.rejected_points.size.should == 0 }
    end

  end

  describe ".pack" do

    context "when using default classes" do
      let(:points) { 100.times.map{ build(:point) } }
      let(:hex_size) { 0.15 }
      subject { HexagonalTiling::Hexagon.pack(points, hex_size, { grab_points: true }) }
      it { subject.class.should == Array }
      it { subject.each{ |hex| hex.collected_points.each{ |p| hex.contains?(p).should == true } } } 
      it { subject.inject([]){ |arr, hex| arr += hex.collected_points }.size.should == points.size }
    end

  end

end