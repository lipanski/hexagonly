# Hexagonly

**Work in progress**

Provides helper classes for performing flat-topped hexagonal tiling and other polygon-related operations.

## Motivation

The ideal shape for grouping objects in a 2-dimensional space is the circle, because every
object adheres to this shape by a given maximum distance from the center. 
However, circles are not fit for generating tiles. 
Hexagons, on the other side, are easily tileable and maintain a more accurate center-to-boundry relationship than squares or rectangles.

I've developed this gem in order to **group geographical coordinates** on a map and compute averages and other funky stuff for every generated hexagon.
I guess it should work with **2D games** and anything else that requires tiling.
Other polygon-related operations 

## Features

- Currently supported shapes: Point, Polygon, Hexagon.
- Define a **Polygon** and check whether a Point lies within its boundries (*crossing count* algorithm).
- Define a **Hexagon** and determine its boundries, based on the hexagon center and size. All **Polygon** methods apply to this shape as well.
- Generate **neighbouring Hexagons** for a given Hexagon.
- **Hexagonal tiling**: generate hexagons to fill up a space, based on the space boundries (two points suffice) and the hexagon size.
- **Hexagonal tiling & collecting objects on the way**: generate hexagons to match the boundries of a given collection of Points (a *space*), then store contained Points (or custom Objects) for every Hexagon.
- Convert shapes (Polygon, Hexagon, Point) and mixed collections of shapes to **GeoJson**.
- For every defined shape you can either use pre-defined classes or use your own custom classes, by including the appropriate **Hexagonly shape module**.

The gem currently supports *flat-topped* hexagons only. For *pointy-topped* hexagons just place a bug request and I'll look into it.

## Installation

Add this line to your application's Gemfile:

    gem 'hexagonly'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hexagonly

## Usage

### Hexagonal tiling

You start by defining your boundries. Boundries are basically an Array of Hexagonaly::Point objects (2 or more).
There are 3 possible ways of defining Points:

1. By using the pre-defined ``Hexagonly::Point`` class: 

  ```ruby
  boundries = [
    Hexagonal::Point.new(1, 2),
    Hexagonal::Point.new(4, 5)
  ]
  ```

2. Another way would be to use your custom class (e.g. think ActiveRecord) by including ``Hexagonly::Point::Methods`` 
inside your class definition. Then you'll need to supply your class with :x and :y accessors.

  ```ruby
  class MyCustomPoint
    include Hexagonly::Point::Methods
    
    attr_accessor :x, :y
    def initialize(x, y)
      @x, @y = x, y
    end
  end
  
  boundries = [
    MyCustomPoint.new(1, 2),
    MyCustomPoint.new(4, 5)
  ]
  ```
  
3. The last and most customizable method would be to use your custom class and have own attributes work as coordinate getters and setters.
This is accomplished via the class method ``x_y_coord_methods`` which takes two arguments: the names of the x and y coordinate accessors.

  ```ruby
  class MyCustomPoint
    include Hexagonly::Point::Methods
    x_y_coord_methods :a, :b
    
    attr_accessor :a, :b
    def initialize(a, b)
        @a, @b = a, b
    end
  end
  
  boundries = [
    MyCustomPoint.new(1, 2),
    MyCustomPoint.new(4, 5)
  ]
  ```
  
Once you've defined your boundries, you'll want to call the ``Hexagon.pack`` method. This takes 3 arguments:
- the *boundries* or *points* that mark your hexagon field
- half of the horizontal width of your hexagons
- a *Hash* of additional parameters:
  - ``:hexagon_class``: the class used to instanciate new Hexagons. Defaults to ``Hexagonly::Hexagon``. If you are
  using custom Hexagon classes, you should include your class here.
  - ``:point_class``: the class used to instanciate Hexagon center points. Defaults to ``Hexagonly::Point``.
  - ``:grab_points``: a boolean, determining whether the first argument (points / boundries) will also be used to collect
  contained points for every generated hexagon (see next category).
  - ``:reject_empty``: a boolean, determining whether generated hexagons with no collected points should be removed from
  the result. Only works if ``:grab_points`` is enabled (see next category).

```ruby
# Generated Hexagons will be Hexagonly::Hexagon instances
hexagons = Hexagon.pack(boundries, 0.3)

# Generated Hexagons will be MyCustomHexagon instances
hexagons = Hexagon.pack(boundries, 0.3, { :hexagon_class => MyCustomHexagon })
```

### Hexagonal tiling & collecting objects on the way

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
