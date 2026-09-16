# The tools drawer

The Tools (right) drawer is opened from the button on the top right of the main view. It groups map/feature tools together with a few extra actions.

<!-- NEEDS SCREENSHOT: images/tools_drawer.png -->
:::{figure} images/tools_drawer.png
:alt: The complete tools drawer
:width: 30%
:align: center

The complete tools drawer.
:::

## Project Info

Shows the path to the current project database and lets you share the file with other apps.

## Project Stats

Opens a page with statistics about the current project's content (logs, notes, forms).

## Position Tools

- **Go to**: uses the device's geocoding service to look up an address and move the map to the result (only shown when a geocoding service is available on the device).
- **Go to coordinate**: move the map directly to a longitude/latitude pair typed in as `lon,lat`.
- **Share position**: shares the current GPS position (latitude, longitude, altitude, accuracy, timestamp, plus an OpenStreetMap link) through the device's usual sharing options.

## Extras

- **Toggle editing**: shows or hides the pencil button that reveals the editing/query tools in the bottom toolbar - see [Editing tools](editing_tools.md). Off by default.
- **Toggle log info panel**: shows or hides the live elevation/distance panel displayed while a GPS log is being recorded - see [GPS Logging](gps_logging.md). Off by default.
- **Available icons**: opens the icons view.
- **Offline maps**: SMASH has a built-in downloader for Mapsforge map files (see [Supported map types](map_types.md)) covering most of the world; tapping a region starts the download, which can take a while for large countries.

  :::{warning}
  The first time a downloaded Mapsforge map is displayed at a low zoom level, SMASH generates the low-zoom tiles once on the main thread, which can briefly freeze the interface. Letting that one-time generation finish results in smooth navigation afterwards.
  :::

- **Andromaps link**: opens the OpenAndroMaps download page in the browser, for additional Mapsforge-compatible maps.

## Available icons

<!-- NEEDS SCREENSHOT: images/icons_view.png -->
:::{figure} images/icons_view.png
:alt: The icons view
:width: 70%
:align: center

The icons view.
:::

In this view you can pick, from the full set of [Material Design Icons](https://materialdesignicons.com/), which ones should be offered as markers in the notes properties view.

The names shown in this list are also the ones usable in form definitions, as explained in [Form based notes](notes.md#form-based-notes).
