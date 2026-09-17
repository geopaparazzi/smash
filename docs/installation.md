# Installation

SMASH is currently distributed for Android only. The two supported installation channels are F-Droid and the direct APK published with each GitHub release; SMASH is no longer published on Google Play or the Apple App Store.

:::{note}
SMASH is written in Flutter and can technically be compiled for iOS as well - the project still contains an `ios/` build target. However, an iOS release is currently not supported nor distributed, due to missing resources (an Apple Developer account, iOS devices for testing, and maintainer time to build, sign and support it). If you would like to help make an iOS release possible again, get in touch through the channels listed under [Need help?](index.md#need-help).
:::

## From F-Droid (recommended)

SMASH can be installed from [F-Droid](https://f-droid.org/packages/eu.hydrologis.smash/), the free and open source software catalogue for Android.

[![Get it on F-Droid](https://fdroid.gitlab.io/artwork/badge/get-it-on.png)](https://f-droid.org/packages/eu.hydrologis.smash/)

Search for **SMASH** in the F-Droid app, or open the package page directly at <https://f-droid.org/packages/eu.hydrologis.smash/>.


:::{figure} images/fdroid_page.png
:alt: The SMASH entry on F-Droid
:width: 70%
:align: center

The SMASH entry on F-Droid.
:::

Installing through F-Droid also gives you automatic update notifications whenever a new SMASH version is released.

## From the GitHub releases page

For those who prefer not to use F-Droid, every release also ships a downloadable APK on the [SMASH releases page](https://github.com/geopaparazzi/smash/releases). Open the **Assets** section of the latest release and download the **apk** file; if the link is opened directly from an Android device, the system will offer to install it right away.

:::{figure} images/github_release.png
:alt: The GitHub release page, with the apk to download under Assets
:width: 70%
:align: center

The GitHub release page, with the apk to download under Assets.
:::

:::{note}
Installing an APK downloaded outside an app store requires allowing installation from unknown sources for the browser or file manager used to open it; Android will prompt for this automatically on first install.
:::
