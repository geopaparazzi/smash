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

:::{figure} images/simple_notes_dialog.png
:alt: Adding a simple note to the project
:width: 50%
:align: center

Adding a simple note to the project.
:::

When the **note** entry is selected, the note properties view opens directly, ready for editing:

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

:::{figure} images/notes_list.png
:alt: The notes list view
:width: 90%
:align: center

The notes list view.
:::

From here notes can be zoomed to, edited or deleted using the swipe actions on each entry, and the list's own settings icon (top right) opens the notes view-mode options (icon, label or nothing).

## Form based notes

The second icon from the left on the lower toolbar is for form based notes.

Form based notes allow you to take complex, structured notes containing detailed information. Some example forms are included in the installation of SMASH; the **examples** entry in particular shows all the possible form widgets available.

:::{figure} images/forms_examples.png
:alt: The 'examples' form.
:width: 90%
:align: center

The 'examples' form.
:::

The notes can be saved and modified at any time.

The forms definition files are stored within the project and can be edited either manually (not recommended) or using the FormBuilder. On your device, they are typically located in the `forms` folder within the project directory.

### Building forms visually with the FormBuilder

Rather than hand-editing form definition files, SMASH includes a built-in **FormBuilder** to design forms directly on the device. It is disabled by default; enable it from Settings, under Screen Settings, and it then appears as an entry in the tools drawer's Extras section (see [Settings](settings.md#screen-settings) and [Extras](tools_drawer.md#extras)).

:::{figure} images/formbuilder.png
:alt: The FormBuilder
:width: 90%
:align: center

Designing a form with the built-in FormBuilder.
:::

The video below walks through building a form with it end to end:

<a href="https://www.youtube.com/watch?v=lRXou2QnE3s" style="display: block; max-width: 560px; margin: 0 auto; position: relative;">
<img src="https://img.youtube.com/vi/lRXou2QnE3s/maxresdefault.jpg" alt="SMASH FormBuilder video thumbnail" style="width: 100%; display: block; border-radius: 10px;">
<span style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 68px; height: 48px; background: rgba(0,0,0,0.75); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
<span style="width: 0; height: 0; border-top: 12px solid transparent; border-bottom: 12px solid transparent; border-left: 20px solid white; margin-left: 4px;"></span>
</span>
</a>

<p style="text-align: center;"><a href="https://www.youtube.com/watch?v=lRXou2QnE3s">Watch "SMASH FormBuilder" on YouTube</a></p>

### Form Based Notes List

Just as for simple notes, long-pressing the button opens the list of form notes, with the same settings icon giving access to the view-mode options.
