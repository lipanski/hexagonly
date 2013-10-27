require 'spec_helper'

describe HexagonalTiling::Point do
  
  describe "#x_coord and #y_coord" do
    
    context "when .set_coord_names WAS NOT used" do

      context "if #x and #y are not defined" do
        before(:all) do
          class TestPoint
            include HexagonalTiling::Point::Methods
          end
        end

        subject { TestPoint.new }
        it { expect {subject.x_coord}.to raise_error(NoMethodError) }
        it { expect {subject.y_coord}.to raise_error(NoMethodError) }
      end

      context "if #x and #y are defined" do
        before(:all) do
          class TestPoint
            include HexagonalTiling::Point::Methods
            attr_accessor :x, :y
            def initialize(x, y); @x, @y = x, y; end
          end
        end

        subject { TestPoint.new(1, 2) }
        it { subject.x_coord.should == 1 }
        it { subject.y_coord.should == 2 }
      end

    end

    context "when .set_coord_names WAS used" do

      context "if given coordinate methods are not defined" do
        before(:all) do
          class TestPoint
            include HexagonalTiling::Point::Methods
            x_y_coord_methods :a, :b
          end
        end

        subject { TestPoint.new(1, 2) }
        it { expect {subject.x_coord}.to raise_error(NoMethodError) }
        it { expect {subject.y_coord}.to raise_error(NoMethodError) }
      end

      context "if given coordinate methods are defined" do
        before(:all) do
          class TestPoint
            include HexagonalTiling::Point::Methods
            x_y_coord_methods :a, :b
            attr_accessor :a, :b
            def initialize(a, b); @a, @b = a, b; end
          end
        end

        subject { TestPoint.new(1, 2) }
        it { subject.x_coord.should == 1 }
        it { subject.y_coord.should == 2 }
      end
      
    end

  end

end