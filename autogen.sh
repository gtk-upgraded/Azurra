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

# copy correct metacity theme
if [ $COLOR == "dark" ];
then
 cp -a "$ROOTDIR/metacity-1-dark" "$TARGETDIR/metacity-1"
else
 cp -a "$ROOTDIR/metacity-1" "$TARGETDIR"
fi

# copy correct xfwm theme
if [ $COLOR == "dark" ];
then
 cp -a "$ROOTDIR/xfwm4-dark" "$TARGETDIR/xfwm4"
else
 cp -a "$ROOTDIR/xfwm4" "$TARGETDIR"
fi

# open work directory
cd "$ROOTDIR/gtk-2.0"

if [ $COLOR == "dark" ];
then
 cp -a gtkrc-dark "$TARGETDIR/gtk-2.0/gtkrc"
else
 cp -a gtkrc "$TARGETDIR/gtk-2.0/gtkrc"
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
