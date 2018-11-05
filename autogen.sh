#!/bin/bash

# Remove previous compilation if exists
echo -n "Cleaning up..."
rm -rf package/*

# Build theme tree
echo " Done."
echo -n "Setting up file structure..."
cp -a common/xfwm4 package
cp -a common/gtk-2.0 package
cp common/index.theme package
mkdir package/gtk-3.0

# open work directory
cd common/gtk-3.0

# compile SCSS
echo " Done."
echo -n "Compiling..."
sass -C --sourcemap=none _gtk.scss gtk.css
sass -C --sourcemap=none _common.scss gtk-widgets.css

# Create folders and move files
cp -a assets ../../package/gtk-3.0
cp gtk.css ../../package/gtk-3.0
cp gtk-widgets.css ../../package/gtk-3.0
echo " Done."
