# Import

SMASH currently supports importing data from the [Geopaparazzi Survey Server](gss.md) (GSS).

:::{figure} images/import_view.png
:alt: The import view
:width: 100%
:align: center

The import view.
:::

Each entry in the list has its own settings icon (when applicable) to configure that import source; for GSS this opens the server URL/password/project settings directly if none has been configured yet.

When entering the GSS import view, a list of datasets, projects and forms available from the server is presented; tapping the download icon next to an entry downloads it to the device. Once downloaded, the view updates to show what is still available.

# Export

SMASH can export the project's data to a few common file formats, and can synchronize it with the [Geopaparazzi Survey Server](gss.md).

:::{figure} images/export_view.png
:alt: The export view
:width: 100%
:align: center

The export view.
:::

## GPX

Exports the whole survey project to a single GPX file, saved to the export folder in the application directory.

## KML

Exports the whole survey project to a single KML file, saved to the export folder in the application directory.

## GEOPACKAGE

Exports the whole survey project to a single Geopackage file, saved to the export folder in the application directory.

## Export images to folder

Exports all the pictures attached to notes to a folder, for use outside of SMASH.

## GSS

Shows a stats page listing what would be uploaded if the **upload** button is pressed. If the device is not registered with the server, the upload is stopped and an error is shown instead. Like the import side, this entry's settings icon opens the GSS server/project configuration directly if none has been set yet.

:::{figure} images/gss_export_stats.png
:alt: The GSS export stats view
:width: 80%
:align: center

The GSS export stats view.
:::

