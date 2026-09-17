# SMASH Reference Manual

[G-ANT](https://g-ant.eu) - SMASH version 1.12.0, 2026-09

## SMASH, the free and open source digital field mapping app for Android

:::{note}
If you are looking for the source code of this project, [jump right to this link](https://github.com/geopaparazzi/smash).
:::

SMASH is a digital field mapping application developed to perform fast qualitative engineering/geologic surveys and GIS data collection.

The main aim of SMASH is to have a tool that:

- is open source
- fits in any pocket and can be always at hand, when needed
- gives the possibility to take geo-referenced and possibly orientated pictures during a survey, with further possibility to import them into GIS applications
- is able to easily exploit an Internet connection, if available
- is extremely easy to use and intuitive, providing just few important functions

:::{figure} images/smash_on_android.png
:alt: SMASH on Android
:width: 40%
:align: center

SMASH on Android.
:::

The main features available in SMASH are:

- geo-referenced notes and pictures
- GPS track logging, with the possibility to nest or merge several recordings together
- form-based data surveys
- a map view for navigation with support for raster and vector data
- an always-available distance/area measurement tool
- vector feature editing and querying for Geopackage layers
- geopackage (OGC standard) support
- easy export of collected data, and synchronization with the Geopaparazzi Survey Server

### License

The SMASH source code is licensed under the [GNU General Public License, Version 3](https://github.com/geopaparazzi/smash/blob/master/LICENSE).

### Community

SMASH is closely related to the older, more mature, Android-only app Geopaparazzi. For that reason they share the same channels and spaces.

Find out the [latest SMASH news](http://jgrasstechtips.blogspot.com/search/label/smash).


The main communication channels in the past for SMASH users and developers have been mailing lists.
We now decided to move the main communication to the [discussions page](https://github.com/geopaparazzi/smash/discussions).


You can even contribute to this manual. This particular copy of the manual lives alongside the SMASH source code, under `docs/`, so that documentation changes can travel together with the feature changes that motivate them.

Help [translate SMASH on Hosted Weblate](https://hosted.weblate.org/engage/smash/).

(need-help)=
### Need help?

Drop a note on the [discussions page](https://github.com/geopaparazzi/smash/discussions).

### Found bugs?

If you found a bug, please report it in our [issue tracker](https://github.com/geopaparazzi/smash/issues). We will check it and work on it as soon as we can.

### Need features?

If you would like to see new features in SMASH, you have a few ways to get there:

- develop them yourself and [contribute them to the project via pull requests](https://help.github.com/articles/using-pull-requests)
- hire someone to do that for you - get in touch with us, custom development services is what makes it possible to keep SMASH evolving and free.
- create a new feature request in our issue tracker and wait for someone interested to pick it up.

```{toctree}
:maxdepth: 3
:caption: Contents

installation
getting_started
main_view
notes
gps_logging
layers_list
editing_tools
measurement_tool
tools_drawer
main_drawer
import_export
gss
settings
map_types
layers_style
folder_structure
appendix_raster_reprojection
```
