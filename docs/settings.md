# Settings

<!-- NEEDS SCREENSHOT: images/settings_view.png -->
:::{figure} images/settings_view.png
:alt: The settings view
:width: 40%
:align: center

The settings view.
:::

## GPS Settings

In the GPS settings you can define distance/time based filters for logging activity, and view the count of _valid_ vs _all_ GPS points collected.

The GPS filter (a Kalman filter applied to raw GPS data) is **on by default**: it is used wherever GPS-derived length/position is shown or exported, unless turned off here.

:::{note}
The original and filtered GPS signal are **both** always saved to the database, regardless of this setting; you can always choose which one to look at per log from the [GPS Logging List](gps_logging.md#gps-logging-list).
:::

It is also possible to simulate a GPS log (the device still needs a real GPS fix for this to work) - handy for demoing the logging functionality indoors while near a window or otherwise having a fix.

A second, _Live Preview_ tab shows in detail the raw points as they come from the GPS, with their attributes and the effect of the filters applied.

## Screen Settings

- toggle the screen-always-on behaviour
- enable Retina screen mode (needs re-entering the layer view to apply)
- choose which color picker style to use across the app
- style the map center cross (color, size, line width)
- set the size of the main view's toolbar icons
- customize which buttons appear in the bottom toolbar (add note, add form note, add log, GPS button, layers, zoom, edit toggle)
- toggle the GPS log info panel (see [GPS Logging](gps_logging.md))
- enable the (experimental) Formbuilder entry in the tools drawer's Extras section.

## Camera Settings

Choose the picture resolution used for photos: high, medium or low.

## Vector Layers

- the amount of data loaded per layer, useful for large vector datasets that would otherwise make map navigation less smooth (_all_, or a fixed number of features between _50_ and _10000_)
- whether to load data only for the currently visible map area
- the tap radius used by the info/query and editing tools
- the size of the editing drag handles and of the intermediate drag handles.

## CRS

Lists the coordinate reference systems supported by the application, with the possibility to add new ones by EPSG code. These are used to reproject vector datasets (Geopackage layers and shapefiles) onto the map.

## Device Settings

Shows the device id, used for example to identify a surveyor when synchronizing with the [Geopaparazzi Survey Server](https://www.geopaparazzi.org/gss/index.html). It can be overridden where an organization needs a standardized id scheme.

## GSS Settings

Sets the server URL, password and (once available) selected project used to synchronize with an instance of the [Geopaparazzi Survey Server](https://www.geopaparazzi.org/gss/index.html). This is also reachable directly from the GSS import/export screens if no project is selected yet.

## Diagnostics Settings

Shows full debug information and lets you filter on the main application errors.

## Exit

Use the **Exit** entry to close the application, rather than the OS back gesture, if you want background GPS/logging activity to actually stop.
