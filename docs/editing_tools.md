# Editing tools

Editing (and querying) vector data is opt-in and off by default. It is enabled with the pencil-shaped button in the bottom toolbar; that button itself only appears if the "Toggle editing" option is turned on, either from the right drawer or from Settings.

:::{figure} images/edit_toggle_button.png
:alt: The editing toggle button and the tools it reveals
:width: 100%
:align: center

The editing toggle button and the tools it reveals.
:::

:::{figure} images/edit_on.png
:alt: The editing tools column revealed after toggling editing on
:width: 40%
:align: center

The editing tools column revealed after toggling editing on.
:::

Once toggled on, a small column of tools appears on the left side of the map view: feature editing and feature query. Tapping the toggle button again hides the tools and, if a feature was being edited, cancels any pending unsaved editing session.

## Feature editing

The feature editing tool works on vector layers for all feature types (points, lines, polygons) and in their own coordinate reference system. It allows you to:

- modify existing geometries
- add a new geometry
- delete an existing geometry.

:::{figure} images/feature_editing_selected.png
:alt: A long-tapped polygon feature, selected for editing
:width: 100%
:align: center

A long-tapped polygon feature, selected for editing.
:::

Once activated, **long tap** on a feature in the map to select it.

The selected feature is highlighted on the map, and dedicated editing actions appear in the bottom toolbar to delete it, edit its attribute table, save the modified geometry, or cancel the changes made since the last save.

Destructive actions need a long tap confirmation to prevent accidental modifications.

### Editing existing features

Editing an existing geometry consists of:

- dragging edges/vertices to a new position
- dragging the midpoint of a segment: this turns it into a new vertex, and two additional midpoints are automatically added on either side of it
- long-tapping a vertex to remove it.

As soon as the modified geometry looks right, save the changes with the save icon, or cancel them to restore the geometry as it was at the last save. Both actions close the editing session for that feature.

Editing a feature's attributes is available both from the editing toolbar and from the query tool: select the attribute-table icon to open and edit the current feature's attributes, which save automatically as they are changed.

### Adding new features

To add a new feature to one of the visible vector layers, tap the desired position on the map:

1. SMASH asks in which of the eligible layers to create the new feature
2. once a layer is picked, a new feature of that layer's geometry type is created at the tapped position - a point for point layers, a small two-vertex line for line layers, or a small polygon for polygon layers
3. the new line or polygon can then be reshaped following the same steps as for editing existing features.

It is possible to add new vertexes in different ways:

- drag the midpoint of a segment to create a new vertex, just like when editing an existing feature
- tap anywhere on the map
- add a vertex in the maps's crosshair position
- add a vertex in the current gps position

### Deleting features

To delete an existing feature: long-tap it to select it, then tap the trash icon in the editing toolbar.

:::{warning}
Deletion cannot be undone from the UI - there is no undo/cancel available once a feature has been deleted.
:::

## Query features

The query tool lets you tap the map to inspect all visible vector layers at that position. It opens a feature info view showing every matching feature, highlighted on the map, together with its attributes.

- if more than one feature matches, use the arrows at the top of the window to browse between them
- attributes of features belonging to a Geopackage layer can be edited directly from this view, using the pencil next to each attribute's value.

:::{figure} images/query_tool.png
:alt: The query tool showing feature attributes
:width: 100%
:align: center

The query tool showing feature attributes.
:::
