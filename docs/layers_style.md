(layerstyle)=
# Layers style

SMASH supports layer styling through the [OGC SLD standard](https://opengeospatial.github.io/e-learning/sld/text/main.html). Several GIS and editors support SLD as well, so a style can be authored on a desktop GIS and shipped together with the data to the device. SMASH renders Geopackage and GPX vector layers according to their own SLD file (if one was created beforehand in a GIS), and also lets you create a simple style for those two layer types directly inside the app.

To create or edit a style, open the layers list and swipe the layer to the right to enter its style properties.

## Style a Geopackage layer

For a polygon layer it is possible to edit the _fill_ and _stroke_ properties; for a line layer, only the _stroke_; for a point layer, the _shape_, the _fill_, and labeling of the features.

:::{note}
Remember to **save** using the floating action button at the bottom - this writes the style to the database table.
:::

SMASH also supports one type of theming: styling by **unique values**. In this case a `FeatureTypeStyle` is populated with several rules, each matching a filter on unique values from the attribute table. If a thematic style already exists for a layer, its properties page offers buttons to add, change and remove rules.

## Style a GPX layer

The style properties of a GPX layer are saved to an SLD sidecar file next to it, to ensure the style persists across sessions. Lines and points can both be styled; if waypoints carry a **name** tag, it can be used for labeling.

## Different layer types

Different layer types have different styling options. Here a few examples.


### Shapefile

:::{figure} images/style_shp.png
:alt: Shapefile with theming and labeling options
:width: 80%
:align: center

Shapefile with theming and labeling options.
:::

### GPX

:::{figure} images/style_gpx.png
:alt: GPX layer styling options
:width: 80%
:align: center

GPX layer styling options.
:::

### Geopackage lines

:::{figure} images/style_gpkg.png
:alt: Geopackage line layer styling options
:width: 80%
:align: center

Geopackage line layer styling options.
:::

### Geojson polygons

:::{figure} images/style_geojson.png
:alt: Geojson polygon layer styling options
:width: 80%
:align: center

Geojson polygon layer styling options.
:::