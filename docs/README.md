# SMASH user manual

This is the SMASH user manual, in MyST Markdown for Sphinx, kept alongside the app source so documentation changes can travel with the feature changes that motivate them, and built on [Read the Docs](https://readthedocs.org/). It replaces the copy previously maintained at `geopaparazzi-usermanual/userguide/smash` (AsciiDoc), which had fallen far behind the app (its screenshots and several described interactions dated back to 2020, version 1.3.0).

## Building locally

```sh
pip install -r requirements.txt
sphinx-build -b html . _build/html
```

Then open `_build/html/index.html`. Read the Docs builds the same way automatically on push, driven by `.readthedocs.yaml` at the repository root.

## File structure

`index.md` is the book entry point (title, intro, license, community) with a `toctree` listing every chapter below it, in reading order. The old manual was a single 1,182-line `main_view.adoc`; it has been split into one file per topic:

| File | Covers |
|---|---|
| `installation.md` | F-Droid / GitHub APK install, iOS status |
| `getting_started.md` | Launching the app, project selection |
| `main_view.md` | Main view overview, GPS info button, zoom buttons |
| `notes.md` | Simple and form-based notes |
| `gps_logging.md` | Recording, listing, nesting/merging, tagging logs |
| `layers_list.md` | The layers list in the main view |
| `editing_tools.md` | The editing toggle, feature editing, query tool |
| `measurement_tool.md` | The always-on ruler/area tool |
| `tools_drawer.md` | Right drawer: project info/stats, position tools, extras |
| `main_drawer.md` | Left drawer: projects, import, export, settings, help, about |
| `import_export.md` | Import and Export screens |
| `settings.md` | All settings sub-screens |
| `map_types.md` | Supported data/map formats |
| `layers_style.md` | SLD styling of Geopackage/GPX layers |
| `folder_structure.md` | The `smash/` folder layout on device |
| `appendix_raster_reprojection.md` | Geopackage raster reprojection details |

Cross-references between chapters are plain Markdown links to `file.md#heading-slug` (MyST auto-generates heading anchors, enabled via `myst_heading_anchors` in `conf.py`); admonitions use MyST's `:::{note}` / `:::{warning}` / `:::{tip}` fenced directives, and images use `:::{figure}`.

## What changed in this pass

Everything above was rewritten or reorganized while cross-checking against the current app source (`smash` + `smashlibs`), not just carried forward from the old text. Concretely verified and corrected in this pass:

* Distribution is Android-only via F-Droid / GitHub releases (no Play Store, no App Store); iOS is buildable but not currently released.
* Coach marks are dead code (a preference flag is set, but nothing is ever shown) - removed from the manual entirely.
* The GPS info button's status colors, tap/long-press behavior, and the GPS-centering toggle (now a button inside the long-press panel, not a double-tap gesture) were re-derived from `gps_info_button.dart`.
* The "double tap to open view-mode settings" gesture no longer exists anywhere (notes, logs, layers); those settings now live behind a cog icon inside each list screen.
* GPS logs can be grouped two different ways - non-destructive parent/child **pieces**, and destructive **merge** - which the old manual conflated into one; both are now documented separately, along with log tagging/filtering.
* The bottom toolbar's activation ("a handler in the lower right corner") is now the "Toggle editing" pencil button, off by default, showing only Edit + Query tools.
* The measurement tool was moved out of that toggle-gated toolbar to an always-available button below the zoom controls, and now also computes the **area** of the path when it closes into a valid (non self-intersecting) polygon.
* Import/Export plugin lists were checked against `plugins.dart`: GTT and the legacy "GSS (until 2022)" variants are gone; **PDF export code exists but is not currently registered/reachable from the Export screen** - flagged rather than documented as available.
* The main/left and tools/right drawers were re-derived from `mainview_utils.dart` (eg. added Project Stats, Go to coordinate, Andromaps link, Online Help, About - none of which were in the old manual).

Sections that are foundational and weren't touched by anything in the current development pass - Geopackage/GPX/Shapefile/GeoJSON/MBTiles/Mapsforge/mapurl format support, SLD layer styling, CRS settings, raster reprojection - were carried forward with lighter re-verification, since nothing pointed to them having changed. If something in those areas looks off, it's more likely stale content than a fresh, session-verified fact like the items above.

## Screenshots

None of the old manual's ~90 images (all from 2020-2021, iPad/iPhone/Android UI predating the current Material 3 redesign) were copied into `images/` here - carrying forward screenshots that are the exact thing being flagged as outdated didn't seem useful, and it would have added ~117MB of images-to-be-replaced-anyway to this repo. Every image reference below points at a **new**, not-yet-existing file under `images/`, each preceded by a `<!-- NEEDS SCREENSHOT: <path> -->` comment describing what to capture. Drop the real screenshot in at that path once available and the reference will just work.

Full list of screenshots needed:

- `images/fdroid_page.png` - the SMASH page on F-Droid (`installation.md`)
- `images/github_release.png` - the Assets section of a github.com/geopaparazzi/smash release (`installation.md`)
- `images/huge_icon_smash.png` - PDF title-page logo/app icon; may just need copying over from the old manual after confirming it still matches the current app icon (not currently referenced by the HTML build, only relevant if PDF output is added later)
- `images/smash_on_android.png` - a general shot of SMASH running on Android (`index.md`)
- `images/project_selection.png` - the startup project creation/selection screen (`getting_started.md`)
- `images/main_view.png` - the current main map view (top bar, bottom bar, zoom/ruler column) (`main_view.md`)
- `images/gps_info_panel.png` - the GPS info bottom sheet (`main_view.md`)
- `images/simple_notes_dialog.png` - the "Simple Notes" type-selection dialog (`notes.md`)
- `images/note_properties.png` - the note properties view (`notes.md`)
- `images/notes_list.png` - the notes list view (`notes.md`)
- `images/log_info_panel.png` - the live GPS logging info panel (`gps_logging.md`)
- `images/logs_list.png` - the GPS logs list view (`gps_logging.md`)
- `images/logs_list_pieces_expanded.png` - a parent log expanded to show its pieces (`gps_logging.md`)
- `images/layers_list.png` - the layers list view (`layers_list.md`)
- `images/edit_toggle_button.png` - the editing toggle button and the tools it reveals (`editing_tools.md`)
- `images/feature_editing_selected.png` - a selected feature ready for editing (`editing_tools.md`)
- `images/measurement_button.png` - the ruler button below the zoom controls (`measurement_tool.md`)
- `images/measurement_area.png` - a closed measurement path showing length + area (`measurement_tool.md`)
- `images/tools_drawer.png` - the right (tools) drawer (`tools_drawer.md`)
- `images/icons_view.png` - the icon picker view (`tools_drawer.md`)
- `images/main_drawer.png` - the left (main) drawer (`main_drawer.md`)
- `images/import_view.png` - the Import screen (`import_export.md`)
- `images/export_view.png` - the Export screen (`import_export.md`)
- `images/gss_export_stats.png` - the GSS export stats view (`import_export.md`)
- `images/settings_view.png` - the Settings screen (`settings.md`)
- `images/sld_layers_list.png` - a layers list containing Geopackage layers, for the styling chapter (`layers_style.md`)

## Still to do

* Take/collect the screenshots above.
* Re-verify the "foundational" sections listed above against source if there's reason to think they've drifted.
* Decide whether to retire `geopaparazzi-usermanual/userguide/smash` or keep it in sync/redirect to this copy.
* Connect the repository on readthedocs.org (import project, point it at this repo; `.readthedocs.yaml` at the repo root is already set up for it).
