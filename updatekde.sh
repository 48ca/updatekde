#!/bin/bash

set -e

if [ "$UID" -ne "0" ]; then
    echo "This script must be executed as root"
    exit
fi

# Set Spotify and Chromium scale factors
for file in /usr/share/applications/spotify.desktop /usr/share/applications/chromium.desktop
do
    if ! [ -f $file ]; then
        continue
    fi
    # Removes only one --force-device-scale-factor declaration
    # if it exists and places a new declaration in
    sed -i'.bak' $file \
        -e 's/\(^Exec=.*\)--force-device-scale-factor=1.5\(.*$\)/\1\2/g' \
        -e 's/\(^Exec=.*$\)/\1 --force-device-scale-factor=1.5/g'

done

# Remove KDE logo from splash screen
if [ -f /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/Splash.qml ]
then
    sed -i'.bak' \
        /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/Splash.qml \
        -e 's/\n\s*source: "images\/kde.svgz"//g'
fi

# Rename GNOME's terminal emulator so it doesn't
# conflict with Xfce4's terminal emulator in krunner
if [ -f /usr/share/applications/org.gnome.Terminal.desktop ]
then
    sed -i'.bak' \
        /usr/share/applications/org.gnome.Terminal.desktop \
        -e 's/^\(Name=\).*$/\1GNOME Terminal/g'
fi
