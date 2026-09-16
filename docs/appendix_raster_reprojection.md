# Appendix 1: Raster reprojection

Visualization of Geopackage raster layers supports configuring the tiling system and projection used. For the tiling system, using GDAL to create Geopackage rasters is recommended: by default GDAL generates a single zoom level at the optimal resolution using the best tile schema, keeping the resulting Geopackage close in size to the original data.

SMASH supports different projections and reprojects on the fly when a layer isn't already in the EPSG:3857 projection used as the map's base.

Geopackage tile datasets can be loaded in two different ways; the relevant settings are in a Geopackage layer's properties view. Options include:

- the opacity of the whole layer
- loading a wider range of tile schemas, useful for an orthophoto reprojected with GDAL and packaged as a Geopackage

  :::{note}
  This has a larger memory footprint, since tiles are loaded in memory as a single image; on datasets too large for the device, it should stay disabled.
  :::

- a color to make transparent - useful to overlay technical maps over an elevation model or orthophoto, and also to fix the case where two reprojected orthophoto Geopackage layers each have a black collar that covers the other layer when stacked. Selecting the collar's black color in the picker makes it transparent.

:::{note}
When JPEG Geopackage tiles are generated, interpolation and antialiasing can leave some pixels not perfectly black, so a few stray pixels of the collar may remain even after setting black to transparent.
:::
