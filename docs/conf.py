"""Sphinx configuration for the SMASH user manual (hosted on Read the Docs)."""

project = "SMASH"
copyright = "2019-2026, G-ANT - manual content licensed under CC BY 4.0"
author = "G-ANT"
release = "1.12.0"

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

exclude_patterns = ["README.md", "_build", ".venv", "Thumbs.db", ".DS_Store"]

html_theme = "furo"
html_title = "SMASH Reference Manual"
html_static_path = ["_static"]
html_css_files = ["custom.css"]

# SMASH's own accent color (SmashColors.mainSelection, #bf360c) used as the
# brand color, so the manual doesn't look like a generic ReadTheDocs site.
html_theme_options = {
    "light_css_variables": {
        "color-brand-primary": "#bf360c",
        "color-brand-content": "#bf360c",
    },
    "dark_css_variables": {
        "color-brand-primary": "#ff8a65",
        "color-brand-content": "#ff8a65",
    },
    "sidebar_hide_name": False,
}
