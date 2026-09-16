# The layers list view

The layers list view shows the currently loaded layers. Since layers lower in the list cover layers above them on the map, the order can be changed by dragging a layer to a new position; that order defines the drawing order of all layers on the map (raster and vector, online and local).

<!-- NEEDS SCREENSHOT: images/layers_list.png -->
:::{figure} images/layers_list.png
:alt: The layers list view
:width: 30%
:align: center

The layers list view.
:::

From this view it is possible to add new layers from the [supported map types](map_types.md) using the icons at the top right of the panel: one to add an _online_ resource and one to add a _local_ resource - the local file browser also supports selecting several files at once, to add them all as layers in a single step.

If a layer has a bounding area (as vector maps or mbtiles layers), swiping it to the right zooms the map to that area and also opens the layer's style/visualization properties.

Swiping a layer to the left removes it.

:::{note}
Local data must have its own projection information file (_.prj_) both for rasters and for vectors. SMASH supports reprojecting, and several CRS are bundled with the application by default. For projections not yet supported, tap on the layer and follow the instructions.
:::

The map decorations (scale bar, projection grid, center cross, GPS position indicator) are configured from Settings, under Screen Settings, rather than from the layers list itself.

# Zoom buttons

The zoom-in and zoom-out buttons let you zoom the map in and out; the same can be achieved with pinch gestures. See [Zoom buttons and the measurement tool](main_view.md#zoom-buttons-and-the-measurement-tool) for their exact position and what sits right below them.
