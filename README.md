# Hexagonly

Provides helper classes for performing flat-topped hexagonal tiling and other polygon-related operations.

## Features

- Currently supported shapes: Point, Polygon, Hexagon.
- Define a **Polygon** and check whether a Point lies within its boundries (*crossing count* algorithm).
- Define a **Hexagon** and determine its boundries, based on the hexagon center and size. All **Polygon** methods apply to this shape as well.
- Generate **neighbouring Hexagons** for a given Hexagon.
- **Hexagonal tiling**: generate hexagons to fill up a space, based on its boundries (two points suffice) and the hexagon size.
- **Hexagonal tiling & collecting objects on the way**: generate hexagons to match the boundries of a given collection of Points (a *space*), then store contained Points (or custom objects) for every Hexagon.
- Convert shapes (Polygon, Hexagon, Point) and mixed collections of shapes to **GeoJson**.
- For every defined shape you can either use pre-defined classes or use your own custom classes, by including the appropriate **Hexagonly shape module**.
- RSpec test suite.

The gem currently supports *flat-topped* hexagons only. For *pointy-topped* hexagons just place a bug request and I'll look into it.

## Installation

Add this line to your application's Gemfile:

    gem 'hexagonly'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hexagonly

## Usage

### Points

There are 2 ways for defining Point objects:

1. By using the pre-defined ``Hexagonly::Point`` class: 

  ```ruby
  point = Hexagonly::Point.new(1, 2)
  
  puts point.x_coord # => 1
  puts point.y_coord # => 2
  ```

2. By using your custom class (e.g. think ActiveRecord) and including ``Hexagonly::Point::Methods`` 
inside your class definition. Then you would assign your own accessors as coordinate getters and setters.
This is accomplished via the class method ``x_y_coord_methods`` which takes two arguments: the names of the x and y coordinate accessors.
The ``x_y_coord_methods`` method defaults to ``:x`` and ``:y``.

  ```ruby
  class MyCustomPoint
    include Hexagonly::Point::Methods
    
    # Sets accessors :a and :b as coordinate accessors
    x_y_coord_methods :a, :b
    
    attr_accessor :a, :b
    def initialize(a, b)
      @a, @b = a, b
    end
  end
  
  point = MyCustomPoint.new(1, 2)
  
  puts point.x_coord # => 1
  puts point.y_coord # => 2
  ```

### Poylgons

The same 2 ways of instanciating apply to Polygons as well:

1. By using the pre-defined ``Hexagonly::Polygon`` class:
   
   ```ruby
   corners = [ Hexagonly::Point.new(2, 1), Hexagonly::Point.new(5, 5), Hexagonly::Point.new(6, 1), ... ]
   poly = Hexagonly::Polygon(corners)

   puts poly.poly_points # => corners...
   puts poly.contains?(Hexagonly::Point(4, 2)) # => true
   ```
  
2. By using custom classes, which include ``Hexagonly::Polygon::Methods`` and assigning custom corner accessor, set via the class method ``poly_points_method``.
The ``poly_points_method`` method defaults to ``:poly_points``.
  
  ```ruby
  class MyCustomPolygon
    include Hexagonly::Polygon::Methods
    
    # Sets :corners as the polygon corners accessor
    poly_points_method :corners
    
    attr_accessor :corners
    def initialize(corners)
      @corners = corners
    end
  end

  corners = [ Hexagonly::Point.new(2, 1), Hexagonly::Point.new(5, 5), Hexagonly::Point.new(6, 1), ... ]
  poly = MyCustomPolygon.new(corners)
  
  puts poly.poly_points # => corners...
  puts poly.contains?(Hexagonly::Point(4, 2)) # => true
  ```

### Hexagons

Hexagons inherit all methods from Polygons. There are 2 ways of creating new Hexagons:

1. By using the pre-defined ``Hexagonly::Hexagon`` class:
   
  ```ruby
  center = Hexagonly::Point.new(4, 4)
  hexagon = Hexagonly::Hexagon.new(center, 1.5)

  puts hexagon.hex_corners # => corners...
  puts hexagon.contains?(center) # => true
  ```

2. By using a custom class, which includes ``Hexagonly::Hexagon::Methods``, and calling ``setup_hex`` on your instance:

  ```ruby
  class MyCustomHexagon
    include Hexagonly::Hexagon::Methods
    
    def initialize(center, size)
      setup_hex(center, size)
    end
  end

  center = Hexagonly::Point.new(4, 4)
  hexagon = MyCustomHexagon.new(center, 1.5)

  puts hexagon.hex_center # => center
  puts hexagon.hex_v_size # => distance from center to the top / bottom borders
  puts hexagon.hex_corners # => corners...
  puts hexagon.contains?(center) # => true
  ```

### Hexagonal tiling

You start by defining your boundries. Boundries are basically a collection of 2 or more ``Hexagonly::Point`` objects or objects including ``Hexagonly::Point::Methods``:

```ruby
# Use the default Point class
boundries = [
  Hexagonly::Point.new(1, 2),
  Hexagonly::Point.new(4, 5),
  ...
]

# Or use a custom class that includes Hexagonly::Point::Methods
boundries = [
  MyCustomPoint.new(1, 2),
  MyCustomPoint.new(4, 5),
  ...
]
```

Once you've defined your boundries, you can pass them to the ``Hexagonly::Hexagon.pack`` method. This takes 3 arguments:
- The *boundries* or *points* that mark your hexagon field.
- The distance from the center to the left / right boundries (half of the desired width of your hexagons).
- A *Hash* of additional parameters:
  - ``:hexagon_class``: The class used to instanciate new Hexagons. Defaults to ``Hexagonly::Hexagon``. If you are
  using custom Hexagon classes, you should include your class here.
  - ``:point_class``: The class used to instanciate Hexagon **center** points. Defaults to ``Hexagonly::Point``.
  - ``:grab_points``: A boolean, determining whether the first argument (points / boundries) will also be used to collect
  contained points for every generated hexagon (see next category).
  - ``:reject_empty``: A boolean, determining whether generated hexagons with no collected points should be removed from
  the result. Only works if ``:grab_points`` is enabled (see next category).

```ruby
# Generated Hexagons will be Hexagonly::Hexagon instances
hexagons = Hexagonly::Hexagon.pack(boundries, 0.3)

# Generated Hexagons will be MyCustomHexagon instances
hexagons = Hexagonly::Hexagon.pack(boundries, 0.3, { :hexagon_class => MyCustomHexagon })
```

### Hexagonal tiling & collecting objects on the way

While generating your hexagons from a collection of Point objects, you might want to **store all contained points within individual hexagons**.
This is accomplished by the same ``Hexagonly::Hexagon.pack`` method, only you'll need to enable the additional ``:grab_points`` parameter.
Enabling the``:reject_empty`` parameter will remove all empty hexagons from the results Array.

```ruby
points = [
  Hexagonly::Point.new(1, 1),
  Hexagonly::Point.new(2, 2),
  Hexagonly::Point.new(2, 3),
  Hexagonly::Point.new(7, 1),
  ...
]

hexagons = Hexagonly::Hexagon.pack(points, 0.25, { :grab_points => true, :reject_empty => true })

puts hexagons[0].collected_points # => all objects from the points variable contained within this hexagon
puts hexagons[0].collected_points[0].class # => Hexagonly::Point or your custom point class
```

### Examples with geographical coordinates

1. [This one](https://github.com/lipanski/hexagonly/blob/master/examples/1.geojson) applies hexagonal tiling & grabbing over a collection of 100 points. The ``:reject_empty`` option is disabled.

2. [This example](https://github.com/lipanski/hexagonly/blob/master/examples/2.geojson) uses the same collection, but the ``:reject_empty`` option has been enabled.

### More examples

While tiling and grabbing objects, you can also mix classes in your ``points`` collection, as long as they are
compatible with ``Hexagonly::Point`` methods:

```ruby
class Salami
  include Hexagonly::Point::Methods

  # .x_y_coord_methods defaults to :x and :y
  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end
end

class Cheese
  include Hexagonly::Point::Methods

  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end
end

class Pizza
  include Hexagonly::Hexagon::Methods
end

# We have a couple of ingredients layed out on the table
ingredients = [
  Salami.new(1, 1),
  Cheese.new(2, 2),
  Cheese.new(3, 3),
  Salami.new(4, 4),
  ...
]

# And we want to create hexagonal pizzas out of them, 
# by just laying the dough on top and removing the extra dough
pizza_size = 1.0
pizzas = Hexagonly::Hexagon.pack(ingredients, pizza_size, { 
  :hexagon_class => Pizza, 
  :grab_points => true, 
  :reject_empty => true }
)

puts pizzas[0].class # => Pizza
puts pizzas[0].collected_points[0].class # => Salami or Cheese
```

## Motivation

A personal project required me to **group geographical coordinates** on a map, compute different stats for individual groups 
and display those stats in such a way that made them visually identify their groups.
Squares and rectangles didn't really work for me, because different points on the boundries aren't equally distanced to the center.
Circles would have been a good option for grouping objects in a 2-dimensional space, but then again
circles are not really *tileable*.
**Hexagons**, on the other hand, combine properties of the two shapes: they are easily tileable and have (sort of) a radius.

I've tested this on my project with > 5000 points, but I guess it should work with **2D games** as well, or anything else that requires tiling or polygon-related operations.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request