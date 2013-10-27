class Polygon
  module Methods
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :poly_method
      
      def set_poly_method(method)
        @poly_method = method
      end
    end

    def poly
      send(self.class.poly_method)
    end

    def poly_test
      puts "poly_test"
    end
  end

  include Methods
end

class Hexagon
  module Methods
    include Polygon::Methods
    
    def self.included(base)
      base.extend(Polygon::ClassMethods)
      base.set_poly_method :hexa_poly
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :hexa_method

      def set_hexa_method(method)
        @hexa_method = method
      end
    end

    def hexa
      send(self.class.hexa_method)
    end

    def hexa_poly
      puts "hexa_poly"
    end

    def contains
      puts "polygon contains"
    end
  end

  include Methods
  set_hexa_method :hexa_hexa

  def hexa_hexa
    puts "hexa_hexa"
  end

  def contains
    puts "hexagon contains"
    super
  end
end

require_relative 'lib/hexagonal_tiling/point'
require_relative 'lib/hexagonal_tiling/polygon'
require_relative 'lib/hexagonal_tiling/hexagon'



class Test
  def initialize(*args)
    puts args.to_s
    bla(*args)
  end

  def bla(a, b, c)
    puts a
    puts b
    puts c
  end
end

Test.new(:a, :b, :c)