#!/bin/bash

# exit if sass isn't installed (rough check)
if [ ! -f /usr/bin/sass ];
then
 echo "WARNING: SASS is needed to compile this theme. Install it before proceeding to generation"
 exit
fi

# set root directory
ROOTDIR="$PWD/common"
TARGETDIR="$PWD/package"

# set variants
COLOR="light"

# set dark if passed as argument
if [ "$1" == "--dark" ];
then
 COLOR="dark"
fi

# if package dir exists
if [ -d "$PWD/package" ];
then

 # Remove previous compilation if exists
 echo -n "Cleaning up..."
 rm -rf "$TARGETDIR"/*
 echo " Done."
else
 mkdir package
fi

# Copy static resources
echo -n "Copying static resources..."
cp "$ROOTDIR/index.theme" "$TARGETDIR"

# Create static folders
mkdir "$TARGETDIR/gtk-2.0"
mkdir "$TARGETDIR/gtk-3.0"
mkdir "$TARGETDIR/gnome-shell"
mkdir "$TARGETDIR/metacity-1"
mkdir "$TARGETDIR/openbox-3"

# copy correct openbox theme
cp -a "$ROOTDIR/openbox-3/"*.xbm "$TARGETDIR/openbox-3"
if [ $COLOR == "dark" ];
then
 cp -a "$ROOTDIR/openbox-3/themerc-dark" "$TARGETDIR/openbox-3/themerc"
else
 cp -a "$ROOTDIR/openbox-3/themerc" "$TARGETDIR/openbox-3/themerc"
fi

# copy correct metacity theme
cp -a "$ROOTDIR/metacity-1/"*.svg "$TARGETDIR/metacity-1"
if [ $COLOR == "dark" ];
then
 cp -a "$ROOTDIR/metacity-1/metacity-theme-2-dark.xml" "$TARGETDIR/metacity-1/metacity-theme-2.xml"
 cp -a "$ROOTDIR/metacity-1/metacity-theme-3-dark.xml" "$TARGETDIR/metacity-1/metacity-theme-3.xml"
else
 cp -a "$ROOTDIR/metacity-1/metacity-theme-2.xml" "$TARGETDIR/metacity-1/metacity-theme-2.xml"
 cp -a "$ROOTDIR/metacity-1/metacity-theme-3.xml" "$TARGETDIR/metacity-1/metacity-theme-3.xml"
fi

# copy xfce-notify theme
cp -a "$ROOTDIR/xfce-notify-4.0" "$TARGETDIR/xfce-notify-4.0"

# copy correct xfwm theme
if [ $COLOR == "dark" ];
then
 cp -a "$ROOTDIR/xfwm4-dark" "$TARGETDIR/xfwm4"
else
 cp -a "$ROOTDIR/xfwm4" "$TARGETDIR"
fi

# open work directory
cd "$ROOTDIR/gtk-2.0"
cp -a gtkrc "$TARGETDIR/gtk-2.0/gtkrc"

if [ $COLOR == "dark" ];
then
 cp -a colors-dark.rc "$TARGETDIR/gtk-2.0/colors.rc"
else
 cp -a colors.rc "$TARGETDIR/gtk-2.0/colors.rc"
fi

cp -a assets "$TARGETDIR/gtk-2.0"
cp -a panel.rc "$TARGETDIR/gtk-2.0"

# open work directory
cd "$ROOTDIR/gtk-3.0"

# setup GTK theme
echo " Done."
echo -n "Compiling GTK theme..."

# compile theme based on color passed
if [ $COLOR == "dark" ];
then
 sass -C --sourcemap=none _gtk-dark.scss gtk.css
else
 sass -C --sourcemap=none _gtk.scss gtk.css
fi

sass -C --sourcemap=none _common.scss gtk-widgets.css

cp -a assets "$TARGETDIR/gtk-3.0"
cp gtk.css "$TARGETDIR/gtk-3.0"
cp gtk-widgets.css "$TARGETDIR/gtk-3.0"

echo " Done."

# open work directory
cd "$ROOTDIR/gnome-shell"

# compile gnome-shell theme
echo -n "Compiling Shell theme..."

sass -C --sourcemap=none _common.scss gnome-shell.css

cp -a gnome-shell.css "$TARGETDIR/gnome-shell"

echo " Done."
