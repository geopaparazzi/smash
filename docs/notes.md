# Notes

SMASH supports different types of notes:

- simple notes
  - simple text notes
  - simple picture notes
- form-based notes

## Simple Notes

To create a simple note tap the first icon of the lower toolbar. The **Simple Notes** dialog appears, allowing you to choose between:

- a text or an image note
- placing the note at the current GPS position or at the current map center, toggled with the position selector shown at the top of the dialog.

<!--
NEEDS SCREENSHOT: images/simple_notes_dialog.png
The "Simple Notes" type-selection dialog, including the GPS/map-center
position selector at the top.
-->
:::{figure} images/simple_notes_dialog.png
:alt: Adding a simple note to the project
:width: 50%
:align: center

Adding a simple note to the project.
:::

When the **note** entry is selected, the note properties view opens directly, ready for editing:

<!-- NEEDS SCREENSHOT: images/note_properties.png -->
:::{figure} images/note_properties.png
:alt: The note properties view
:width: 50%
:align: center

The note properties view.
:::

Tap the text field to edit the note's text; for a newly created note, the default placeholder text is cleared automatically the first time you tap in, so you don't need to delete it by hand. Color, size and icon for the note can also be chosen from this same view.

When the **image** entry is used instead, the camera opens and allows you to save a picture to the project.

If a note is tapped on the map view, a quick-info panel opens, allowing you to share, delete or edit the selected note. If the note is an image note, a thumbnail of the picture is shown.

### Simple Notes List

Long-press the **add note** button to open the notes list.

<!-- NEEDS SCREENSHOT: images/notes_list.png -->
:::{figure} images/notes_list.png
:alt: The notes list view
:width: 50%
:align: center

The notes list view.
:::

From here notes can be zoomed to, edited or deleted using the swipe actions on each entry, and the list's own settings icon (top right) opens the notes view-mode options (icon, label or nothing).

## Form based notes

The second icon from the left on the lower toolbar is for form based notes.

Form based notes allow you to take complex, structured notes containing detailed information. Some example forms are included in the installation of SMASH; the **examples** entry in particular shows all the possible form widgets available.

The notes can be saved and modified at any time.

To understand how to create forms, have a look at the [dedicated section in the geopaparazzi project](https://www.geopaparazzi.org/v600/index.html#_using_form_based_notes). The two projects share the exact same project and form format.

There is only one thing in which SMASH and geopaparazzi forms differ, and that is icons. SMASH supports icons in the single note definition but also in the definition of each widget.

To add an icon to the form definition, a **sectionicon** tag needs to be added to the section. This can be seen in the example forms, for example:

```json
{
  "sectionname": "text note",
  "sectiondescription": "a simple text note",
  "sectionicon": "fileAlt",
  "forms": [
    {
      "formname": "text note",
      "formitems": [
        {
          "key": "title",
          "value": "",
          "icon": "font",
          "islabel": "true",
          "type": "string",
          "mandatory": "no"
        },
        {
          "key": "description",
          "value": "",
          "icon": "infoCircle",
          "type": "string",
          "mandatory": "no"
        }
      ]
    }
  ]
}
```

The same goes for **formitems**, which can also feature an **icon** tag.

The icon name itself can be looked up in the [Available icons](tools_drawer.md#available-icons) section of SMASH.

### Form Based Notes List

Just as for simple notes, long-pressing the button opens the list of form notes, with the same settings icon giving access to the view-mode options.
