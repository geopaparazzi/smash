# GPS Logging

To start logging, tap the **GPS log** button (this requires an active GPS fix). You are prompted to enter a name (and optionally tags) for the log, or to accept the default name generated from the current date and time (**log_YYYYMMDD_HHMMSS**).

Once logging has started, the GPS log button turns into the app's accent color. To stop logging, tap the same button again; you will be asked to confirm before the log is closed.

While logging, an optional live info panel can be shown on the map (large/medium/small, resizable), with the elevation/distance profile of the log in progress. It is off by default; it can be toggled from the right drawer (see [Tools drawer](tools_drawer.md)) or from Settings.

<!-- NEEDS SCREENSHOT: images/log_info_panel.png -->
:::{figure} images/log_info_panel.png
:alt: The live GPS logging info panel
:width: 50%
:align: center

The live GPS logging info panel.
:::

On **Android**, the dynamic GPS notification also shows the logging operation, together with the elapsed time and distance from the start of the current log.

## GPS Logging List

Long-press the **GPS log** button to open the list of GPS logs.

<!--
NEEDS SCREENSHOT: images/logs_list.png
The GPS logs list view (current UI, including logs with a merged
"pieces" group, added after the multi-piece log merge feature).
-->
:::{figure} images/logs_list.png
:alt: The GPS logging list view
:width: 50%
:align: center

The GPS logging list view.
:::

From here logs can be zoomed to, restyled, exported to GPX or deleted using the swipe actions on each entry, or expanded (if made of multiple merged pieces) to inspect and manage the individual pieces. Tapping a log opens its properties, including a profile view where the elevation chart can be scrubbed to highlight the corresponding position on the map.

The list also has a settings icon of its own, offering:

- the view mode for the log's original data and for its filtered data (hidden, solid or transparent)
- tag management for logs.

SMASH applies a mathematical filter (a Kalman filter) to GPS data to smooth and correct the logged track; the original, unfiltered data is always kept in the database as well. By default the app uses the filtered data wherever a log's length or track is shown (list, map, exports); this can be changed in [GPS Settings](settings.md#gps-settings).

## Grouping logs together

When several separate recordings belong to the same physical survey (eg. a walk interrupted and resumed later, or several people logging the same route), SMASH offers two different ways to bring them together, depending on whether you want to keep them as distinct pieces or fold them into one another:

Nesting logs as pieces of a parent log
: From a log's swipe actions, **Add piece** lets you pick another, still ungrouped log to attach underneath it as a child. The parent log then shows a **Show details (N pieces)** toggle in the list: expanding it lists every piece with its own name, day, duration and length, each still individually reachable (properties, restyle, remove from parent) via a small unlink icon, but rolled up together for zoom-to, total length/duration, and elevation gain/loss. This is non-destructive: the underlying GPS points and each piece's own identity are untouched, only a parent/child relationship is recorded, and any piece can be detached again at any time.

  <!-- NEEDS SCREENSHOT: images/logs_list_pieces_expanded.png -->
  :::{figure} images/logs_list_pieces_expanded.png
  :alt: A log expanded to show its pieces
  :width: 50%
  :align: center

  A log expanded to show its pieces.
  :::

Merging logs into one
: The GPS logs list's top-right menu also offers **Select all** / **Unselect all** / **Invert selection** (acting on the logs currently checked visible) and **Merge selected**. Merging is destructive: the GPS points of every selected log are reassigned into the earliest one of the group, and the other logs are deleted outright - there is no parent/child relationship left afterwards, and the operation cannot be undone from the UI. Use this only when you actually want several recordings to become permanently a single log, rather than kept as separately manageable pieces.

## Tagging and filtering logs

Logs can be tagged for organization: open a log's properties and add one or more keywords/tags to it. Tags already used across the project are remembered and offered again for reuse, and can be cleaned up from the **Manage keywords** entry in the GPS logs list settings.

Once logs are tagged, the filter icon in the GPS logs list's app bar opens a multi-selection dialog of all known tags; picking one or more tags narrows the list down to only the (parent) logs carrying at least one of the selected tags. Selecting no tags shows every log again.
