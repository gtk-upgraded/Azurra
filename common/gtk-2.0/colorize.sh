#!/bin/bash

sed -e "s/#4285F4/#$1/" assets.svg > 'assets-new.svg'
sed -e "s/#4285F4/#$1/" assets-dark.svg > 'assets-dark-new.svg'
