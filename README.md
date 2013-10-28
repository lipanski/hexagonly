# Hexagonly

**Work in progress**

Provides helper classes for performing flat-topped hexagonal tiling and other polygon-related operations.

**Motivation**: The ideal shape for grouping objects in a 2-dimensional space is the circle, because every
object adheres to this shape by a given maximum radius computed from the center. 
However, circles are not fit for generating tiles. 
Hexagons, on the other side, are easily tileable and maintain a more accurate center-to-boundry relationship than squares or rectangles.

I've developed this gem in order to group geographical coordinates on a map and compute averages and other funky stuff for every generated tile.
I guess it should work with 2D games and anything else that requires tiling.

## Features

- Currently supported shapes: Point, Polygon, Hexagon.
- Define a **Polygon** and check whether a Point lies within its boundries (*crossing count* algorithm).
- Define a **Hexagon** and determine its boundries, based on the hexagon center and size.
- Generate **neighbouring Hexagons** for a given Hexagon.
- **Hexagonal tiling**: generate hexagons to fill up a space, based on the space boundries (two points suffice) and the hexagon size.
- **Hexagonal tiling collecting objects** on the way: generate hexagons to match the boundries of a given collection of Points (a *space*), then store contained Points (or custom Objects) for every Hexagon.
- Convert shapes (Polygon, Hexagon, Point) and mixed collections of shapes to **GeoJson**.
- For every defined shape you can either use pre-defined classes or use your own custom classes, by including **Hexagonly shape modules**.

The gem currently supports *flat-topped* hexagons only. For *pointy-topped* hexagons just place a bug request and I'll look into it.

## Installation

Add this line to your application's Gemfile:

    gem 'hexagonly'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hexagonly

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request