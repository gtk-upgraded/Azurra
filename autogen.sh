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
declare -a args
args=("$@")

for f in ${!args[@]}
do
 case ${args[$f]} in
  *dark | -d)
   COLOR="dark"
  ;;
  *clear)
   cd $ROOTDIR/gtk-2.0
   
   echo $PWD
   ./render-assets.sh --clear
   
   cd $ROOTDIR/gtk-3.0
   ./render-assets.sh --clear
   
   cd $ROOTDIR
   
   exit
  ;;
  *h|*help)
   echo "--dark          Generates dark variant"
   echo "--clear         Clears the previously rendered assets"
   echo "-h | --help     This view"
   
   exit 0
  ;;
 esac
done

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
echo -n "Copying indexing resources..."
if [ $COLOR == "dark" ];
then
 cp "$ROOTDIR/index.theme-dark" "$TARGETDIR/index.theme"
else
 cp "$ROOTDIR/index.theme" "$TARGETDIR"
fi

# Create static folders
mkdir "$TARGETDIR/gtk-2.0"
mkdir "$TARGETDIR/gtk-3.0"
mkdir "$TARGETDIR/gnome-shell"
mkdir "$TARGETDIR/cinnamon"
mkdir "$TARGETDIR/metacity-1"
mkdir "$TARGETDIR/openbox-3"

# copy corresponding openbox theme
cp -a "$ROOTDIR/openbox-3/"*.xbm "$TARGETDIR/openbox-3"
if [ $COLOR == "dark" ];
then
 cp -a "$ROOTDIR/openbox-3/themerc-dark" "$TARGETDIR/openbox-3/themerc"
else
 cp -a "$ROOTDIR/openbox-3/themerc" "$TARGETDIR/openbox-3/themerc"
fi

# copy corresponding metacity theme
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

# copy corresponding xfwm theme
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
cp panel.rc "$TARGETDIR/gtk-2.0"
cp main.rc "$TARGETDIR/gtk-2.0/"

# gtk2 assets
echo "Rendering GTK2 assets..."
cd assets-render-dark
  ./render-assets.sh -g
  cp -R assets/* ../assets-dark/
cd ..

cd assets-render
  ./render-assets.sh -g
  cp -R assets/* ../assets/
cd ..

if [ $COLOR == "dark" ];
then
 cp -a assets-dark "$TARGETDIR/gtk-2.0/assets"
else
 cp -a assets "$TARGETDIR/gtk-2.0"
fi

# open work directory
cd "$ROOTDIR/gtk-3.0"

# setup GTK theme
echo " Done."
echo -n "Compiling GTK theme..."

# compile theme based on color passed
sass -C --sourcemap=none gtk.scss gtk.css
sass -C --sourcemap=none gtk-dark.scss gtk-dark.css

if [ $COLOR == "dark" ];
then
  mv gtk.css gtk-light.css
  mv gtk-dark.css gtk.css
fi

cp *.css "$TARGETDIR/gtk-3.0"

# gtk3 assets
echo "Rendering GTK3 assets..."

cd assets-render-dark
  ./render-assets.sh -g
  cp -R assets/* ../assets-dark/
cd ..

cd assets-render
  ./render-assets.sh -g
  cp -R assets/* ../assets/
cd ..

if [ $COLOR == "dark" ];
then
 cp -a assets-dark "$TARGETDIR/gtk-3.0/assets"
else
 cp -a assets "$TARGETDIR/gtk-3.0"
fi

echo " Done."

# open work directory
cd "$ROOTDIR/gnome-shell"

# compile gnome-shell theme
echo -n "Compiling Gnome-Shell theme..."

sass -C --sourcemap=none _common.scss gnome-shell.css

cp -a "assets" "$TARGETDIR/gnome-shell"
cp gnome-shell.css "$TARGETDIR/gnome-shell"

echo " Done."


# open work directory
cd "$ROOTDIR/cinnamon"

# compile cinnamon theme
echo -n "Compiling Cinnamon theme..."

sass -C --sourcemap=none _common.scss cinnamon.css

cp -a "assets" "$TARGETDIR/cinnamon"
cp cinnamon.css "$TARGETDIR/cinnamon"

echo " Done."
