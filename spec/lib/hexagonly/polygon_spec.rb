require 'spec_helper'

describe Hexagonly::Polygon do

  describe "#poly_points" do

    context "when .poly_points_method WAS NOT used" do

      context "if #poly_points is not defined" do
        before(:all) do
          class TestPolyWithoutPolyPoints
            include Hexagonly::Polygon::Methods
          end
        end

        subject { TestPolyWithoutPolyPoints.new }
        it { expect { subject.poly_points }.to raise_error(NoMethodError) }
      end
      
      context "if #poly_points is defined" do
        before(:all) do
          class TestPolyWithPolyPoints
            include Hexagonly::Polygon::Methods
            attr_reader :poly_points
            def initialize(points); @poly_points = points; end
          end
        end

        let(:points) { 5.times.map{ build(:point) } }
        subject { TestPolyWithPolyPoints.new(points).poly_points }
        it { subject.class.should == Array }
        it { should == points }
      end

    end

    context  "when .poly_points_method WAS used" do

      context "if given method is defined" do
        before(:all) do
          class TestPolyWithCustomMethod
            include Hexagonly::Polygon::Methods
            poly_points_method :custom_poly_points
            attr_reader :custom_poly_points
            def initialize(points); @custom_poly_points = points; end
          end
        end

        let(:points) { 5.times.map{ build(:point) } }
        subject { TestPolyWithCustomMethod.new(points) }
        it { subject.poly_points.class.should == Array }
        it { subject.poly_points.should == points }
      end

    end

  end

  describe "#contains?" do

    context "when the polygon has less than 3 points" do
      let(:points) { 2.times.map( build(:point)) }
      it { expect { Hexagonly::Polygon.new(nil).contains?(Hexagonly::Point.new(1, 2)) }.to raise_error Exception }
      it { expect { Hexagonly::Polygon.new(points).contains?(Hexagonly::Point.new(1, 2)) }.to raise_error Exception }
    end

    context "when the polygon has 3 or more points and a simple poly was given" do
      # See Wolfram Alpha: (4, 4)(5, 6)(3, 8)(8, 8)(7, 4) polygon
      let(:simple_poly_points) { [[4, 4], [5, 6], [3, 8], [8, 8], [7, 4]].map{ |p| Hexagonly::Point.new(p[0], p[1]) } }
      subject { Hexagonly::Polygon.new(simple_poly_points) }
      it { subject.contains?(Hexagonly::Point.new(4, 6)).should == false }
      it { subject.contains?(Hexagonly::Point.new(6, 6)).should == true }
      it { subject.contains?(Hexagonly::Point.new(3, 3)).should == false }
      it { subject.contains?(Hexagonly::Point.new(6, 7.99)).should == true }
      it { subject.contains?(Hexagonly::Point.new(8, 6)).should == false }
      it { subject.contains?(Hexagonly::Point.new(-6, -6)).should == false }
    end

    context "when the polygon has 3 or more points and a messed up poly was given" do
      # See Wolfram Alpha: (4, 6)(8, 7)(7, 3)(5, 9)(8, 9)(4.2, 2)(5, 4) polygon
      let(:messed_up_poly_points) { [[4, 6], [8, 7], [7, 3], [5, 9], [8, 9], [4.2, 2], [5, 4]].map{ |p| Hexagonly::Point.new(p[0], p[1]) } }
      subject { Hexagonly::Polygon.new(messed_up_poly_points) }
      it { subject.contains?(Hexagonly::Point.new(8, 6)).should == false }
      it { subject.contains?(Hexagonly::Point.new(4, 4)).should == false }
      it { subject.contains?(Hexagonly::Point.new(4.3, 7)).should == false }
      it { subject.contains?(Hexagonly::Point.new(7, 8)).should == true }
      it { subject.contains?(Hexagonly::Point.new(5.1, 4)).should == true }
      it { subject.contains?(Hexagonly::Point.new(6, 4.2)).should == false }
      it { subject.contains?(Hexagonly::Point.new(6, 5)).should == false }
      it { subject.contains?(Hexagonly::Point.new(4.9, 3.5)).should == true }
      it { subject.contains?(Hexagonly::Point.new(6, 6.2)).should == false }
    end

  end
  
end