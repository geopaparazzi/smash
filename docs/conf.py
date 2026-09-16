"""Sphinx configuration for the SMASH user manual (hosted on Read the Docs)."""

project = "SMASH"
copyright = "2019-2026, HydroloGIS S.r.l."
author = "HydroloGIS S.r.l."
release = "1.11.0"

extensions = [
    "myst_parser",
    "sphinx.ext.autosectionlabel",
]

# Cross-file references use `{ref}` with an "document:heading-slug" style
# label (autosectionlabel prefixes every heading's auto-generated label with
# its document path to avoid collisions between identically named headings
# across chapters, eg. "Import" the drawer entry vs "Import" the chapter).
autosectionlabel_prefix_document = True

myst_enable_extensions = [
    "colon_fence",
    "deflist",
]
# Auto-generate anchors for headings up to this depth, so plain markdown
# links like [text](file.md#heading-slug) work without manual anchors.
myst_heading_anchors = 4

source_suffix = {
    ".md": "markdown",
}

exclude_patterns = ["README.md", "_build", "Thumbs.db", ".DS_Store"]

html_theme = "sphinx_rtd_theme"
html_title = "SMASH Reference Manual"
