part of smash_import_export;

/// All available plugins are listed here.
///
/// Each plugin should find its own folder in the import, export and utils packages.
///

List<AImportPlugin> importPlugins = [
  GssImportPlugin(),
];

List<AExportPlugin> exportPlugins = [
  GpxExportPlugin(),
  KmlExportPlugin(),
  GeopackageExportPlugin(),
  ImagesExportPlugin(),
  GssExportPlugin(),
];
