# Hexagonly

**Work in progress**

Provides helper classes for performing flat-topped hexagonal tiling and other polygon-related operations.

## Features

- Define a Point and set its x and y coordinates.
- Define a Polygon and check whether a Point lies within its boundries (*crossing count* algorithm).
- Define a Hexagon and determine its boundries, based on the hexagon center and size.
- Determine neighbouring Hexagons of a given Hexagon.
- **Hexagonal tiling** (or *packing*): generate hexagons to fill up a space, based on the space boundries (two points suffice) and the hexagon size.
- **Hexagonal tiling** and *space packing*: generate hexagons to match the boundries of a given collection of Points, then collect contained Points for every Hexagon.
- Convert shapes (Polygon, Hexagon, Point) and mixed collections of shapes to GeoJson.
- The gem currently supports *flat-topped* hexagons only. For *pointy-topped* hexagons just place a bug request and I'll look into it.

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