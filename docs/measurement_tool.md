# The measurement tool

The measurement (ruler) tool is always available on the map, as a button right below the zoom in/out buttons on the right side of the screen.

To measure, drag a finger across the map: the traced path is drawn on the map, and a badge on the ruler button shows the running total distance.

If the traced path is closed back onto itself into a valid (non self-intersecting) polygon, the area of that shape is also computed and shown next to the distance, and the shape is filled with a light translucent tint so you can see at a glance that it closed correctly. If the path crosses itself, or doesn't form a proper polygon yet, only the distance is shown and no fill is drawn.

:::{figure} images/measurement_area.png
:alt: A measured path that closes into a valid area
:width: 90%
:align: center

A measured path that closes into a valid area.
:::

Lifting the finger clears the current measurement; there is no history of past measurements kept.
