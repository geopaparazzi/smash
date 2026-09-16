(maptypes)=
# Supported map types

## Geopackage

SMASH supports the Geopackage format (SQLite-based), for both raster tiles and vector data.

Geopackage vector layers also support attribute table editing.

Vector layers can be in different projections; they are reprojected on the fly.

## GPX

GPX files can be loaded as layers. SMASH creates separate layers for the waypoint and track information they contain.

GPX layers can also be styled, but since the GPX format itself doesn't carry style information, a GPX layer's style is only persisted for a sidecar SLD file next to it - see [Layers style](layers_style.md).

## Shapefile

Shapefiles (`.shp`, with their companion files) can be loaded as vector layers, same as Geopackage and GPX vector layers.

## GeoJSON

GeoJSON files (`.geojson`, or plain `.json` containing GeoJSON) can be loaded as vector layers as well.

## MBTiles

MBTiles is a file format for storing map tiles in a single SQLite database file. See the [OpenStreetMap wiki](http://wiki.openstreetmap.org/wiki/MBTiles) for more information.

## Mapsforge Format Data

The Mapsforge project provides free and open software for rendering vector data based on OpenStreetMap, using an efficient binary format (usually with extension **.map**) with country-specific downloads. SMASH can render map tiles locally from `.map` files, caching the rendered tiles in a local MBTiles store.

Maps are maintained and distributed by the [Mapsforge](https://github.com/mapsforge/mapsforge) team and can be downloaded from [their download server](http://download.mapsforge.org/), or from within SMASH itself - see [Offline maps](tools_drawer.md#extras).

## Mapurls: online tile sources

By default, SMASH loads OpenStreetMap's Mapnik-rendered tiles from the internet.

Other TMS-served online tile sources can be added using `.mapurl` files, which look like:

```
url=http://tile.openstreetmap.org/ZZZ/XXX/YYY.png
minzoom=0
maxzoom=19
center=11.42 46.8
type=google
format=png
defaultzoom=13
description=Mapnik - OpenStreetMap and contributors, ODbL.
```

The mandatory information is:

- the tile server url, with:
  - `ZZZ` in place of the zoom level
  - `XXX` in place of the tile column
  - `YYY` in place of the tile row

  :::{tip}
  This can be tested in a browser too: <http://tile.openstreetmap.org/9/271/182.png> has ZZZ=9, XXX=271, YYY=182.
  :::

- the minimum supported zoom level (typically 0)
- the maximum supported zoom level (usually not more than 19-21, depending on the server)
- the center of the tile source
- the tile numbering scheme: `type=tms` for standard [TMS](http://en.wikipedia.org/wiki/Tile_Map_Service), or `type=google` for the Google Maps numbering convention.
