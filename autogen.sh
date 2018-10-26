#!/bin/bash

sass -C --sourcemap=none _gtk.scss gtk.css
sass -C --sourcemap=none _common.scss gtk-widgets.css

if [ -d 'gtk-3.0' ]; then
  rm -rf 'gtk-3.0'
fi

mkdir gtk-3.0
mv gtk.css gtk-3.0
mv gtk-widgets.css gtk-3.0
cp -a assets gtk-3.0
