#!/bin/bash

# compile SCSS
sass -C --sourcemap=none _gtk.scss gtk.css
sass -C --sourcemap=none _common.scss gtk-widgets.css

# Remove previous compilation if exists
if [ -d 'gtk-3.0' ]; then
  rm -rf 'gtk-3.0'
fi

# Create folders and move files
mkdir gtk-3.0
mv gtk.css gtk-3.0
mv gtk-widgets.css gtk-3.0
cp -a assets gtk-3.0

# Generate package
mkdir package

cp -a gtk-2.0 package
cp -a gtk-3.0 package
cp -a xfwm4 package
cp index.theme package