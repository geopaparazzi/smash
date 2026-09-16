# The Main View

After selecting the project, the main map view appears.

All the features that need to be quickly accessed, such as GPS logging, notes creation, as well as the visualization of the current position on a map are accessible from that view.

<!--
NEEDS SCREENSHOT: images/main_view.png
The current main map view, showing the top bar (drawer button, project
menu), the bottom bar (notes/log actions, edit toggle), the zoom + ruler
column on the right, and the layers/menu icons.
-->
:::{figure} images/main_view.png
:alt: The main view of SMASH
:width: 50%
:align: center

The main view of SMASH.
:::

From the main view the following primary functions can be accessed:

- center map on GPS, and open the GPS info panel
- take notes (simple or form-based) and open the corresponding notes list
- create a GPS log and open the logs list
- open the layer view
- toggle the editing tools (off by default; see [Editing tools](editing_tools.md))
- measure distances and areas on the map (always available; see [The measurement tool](measurement_tool.md))
- open the project information and share dialog
- open the left side drawer with the main menu
- open the right side drawer with the tools section

## GPS info button

The central bottom button is the GPS info button. Its background color reflects the current GPS status:

- a light red/salmon background means the GPS is off, has no permission, or is not available
- a light orange background means the GPS is on but no fix has been acquired yet
- a green background means the GPS is on and has a fix, but no log is being recorded
- the app's accent color (a deep orange/red) means a GPS log is currently being recorded

:::{note}
Unlike older versions, the "logging" state no longer uses a blue color - it uses the app's own accent color, to stay consistent with the current Material 3 theme.
:::

Tapping the button centers the map on the last known GPS position, when available.

Long-pressing the button opens a bottom sheet with the current GPS information: latitude, longitude (each tappable to copy its value to the clipboard), altitude, accuracy, heading, speed, timestamp, and the count of all vs. filtered GPS points collected so far.

<!-- NEEDS SCREENSHOT: images/gps_info_panel.png -->
:::{figure} images/gps_info_panel.png
:alt: The GPS info panel
:width: 50%
:align: center

The GPS info panel.
:::

At the bottom of that panel there is a magnet icon: tapping it toggles automatic map centering on the GPS position while it updates. When active, a small magnet badge is shown on the main GPS info button itself.

To close the GPS info panel just swipe it down.

On **Android**, the GPS position notification is dynamic: it shows the current GPS status and position, and while logging also elapsed time and distance, directly in the notification shade.

## Zoom buttons and the measurement tool

The zoom-in and zoom-out buttons are on the right side of the map view; the same can be done using pinch gestures. Right below them sits the measurement (ruler) button, always available regardless of any other tool state - see [The measurement tool](measurement_tool.md) for details.
