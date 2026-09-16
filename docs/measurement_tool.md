# The measurement tool

The measurement (ruler) tool is always available on the map, as a button right below the zoom in/out buttons on the right side of the screen - unlike editing and querying, it does not need to be toggled on first.

<!--
NEEDS SCREENSHOT: images/measurement_button.png
The ruler button below the zoom controls, both idle and while showing
a length/area badge during a drag.
-->
:::{figure} images/measurement_button.png
:alt: The measurement tool button, below the zoom buttons
:width: 50%
:align: center

The measurement tool button, below the zoom buttons.
:::

To measure, drag a finger across the map: the traced path is drawn on the map, and a badge on the ruler button shows the running total distance.

If the traced path is closed back onto itself into a valid (non self-intersecting) polygon, the area of that shape is also computed and shown next to the distance, and the shape is filled with a light translucent tint so you can see at a glance that it closed correctly. If the path crosses itself, or doesn't form a proper polygon yet, only the distance is shown and no fill is drawn.

<!--
NEEDS SCREENSHOT: images/measurement_area.png
A closed, valid measurement path showing both the distance and the
computed area in the badge, with the translucent fill.
-->
:::{figure} images/measurement_area.png
:alt: A measured path that closes into a valid area
:width: 50%
:align: center

A measured path that closes into a valid area.
:::

Lifting the finger clears the current measurement; there is no history of past measurements kept.
