# Editing tools

Editing (and querying) vector data is opt-in and off by default. It is enabled with the pencil-shaped button in the bottom toolbar; that button itself only appears if the "Toggle editing" option is turned on, either from the right drawer or from Settings.

<!--
NEEDS SCREENSHOT: images/edit_toggle_button.png
The bottom toolbar's pencil "toggle editing" button, and the left-side
tools column (Edit + Query icons) it reveals when tapped.
-->
:::{figure} images/edit_toggle_button.png
:alt: The editing toggle button and the tools it reveals
:width: 60%
:align: center

The editing toggle button and the tools it reveals.
:::

Once toggled on, a small column of tools appears on the left side of the map view: feature editing and feature query. Tapping the toggle button again hides the tools and, if a feature was being edited, cancels any pending unsaved editing session.

:::{note}
The measurement (ruler) tool is **not** part of this toggle - it is always available, next to the zoom buttons; see [The measurement tool](measurement_tool.md).
:::

## Feature editing

The feature editing tool works on vector layers in the Geopackage format, for all feature types (points, lines, polygons) and in their own coordinate reference system. It allows you to:

- modify existing geometries
- add a new geometry
- delete an existing geometry.

<!-- NEEDS SCREENSHOT: images/feature_editing_selected.png -->
:::{figure} images/feature_editing_selected.png
:alt: A long-tapped polygon feature, selected for editing
:width: 30%
:align: center

A long-tapped polygon feature, selected for editing.
:::

Once activated, **long tap** on a feature in the map to select it (for polygons: the geometry below the tap; for lines and points: the nearest one within a tolerance). That tolerance can be configured in Settings, under Vector Layers, as the info/editing tap radius.

The selected feature is highlighted on the map, and dedicated editing actions appear in the bottom toolbar to delete it, edit its attribute table, save the modified geometry, or cancel the changes made since the last save.

### Editing existing features

Editing an existing geometry consists of:

- dragging edges/vertices to a new position
- dragging the midpoint of a segment: this turns it into a new vertex, and two additional midpoints are automatically added on either side of it
- long-tapping a vertex to remove it.

As soon as the modified geometry looks right, save the changes with the save icon, or cancel them to restore the geometry as it was at the last save. Both actions close the editing session for that feature.

Editing a feature's attributes is available both from the editing toolbar and from the query tool: select the attribute-table icon to open and edit the current feature's attributes, which save automatically as they are changed.

### Adding new features

To add a new feature to one of the visible Geopackage layers, long-tap the desired position on the map:

1. SMASH asks in which of the eligible layers to create the new feature
2. once a layer is picked, a new feature of that layer's geometry type is created at the tapped position - a point for point layers, a small two-vertex line for line layers, or a small polygon for polygon layers
3. the new line or polygon can then be reshaped following the same steps as for editing existing features.

### Deleting features

To delete an existing feature: long-tap it to select it, then tap the trash icon in the editing toolbar.

:::{warning}
Deletion cannot be undone from the UI - there is no undo/cancel available once a feature has been deleted.
:::

## Query features

The query tool lets you tap the map to inspect all visible vector layers at that position. It opens a feature info view showing every matching feature, highlighted on the map, together with its attributes.

- if more than one feature matches, use the arrows at the top of the window to browse between them
- attributes of features belonging to a Geopackage layer can be edited directly from this view, using the pencil next to each attribute's value.
