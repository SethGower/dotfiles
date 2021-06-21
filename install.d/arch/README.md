# Arch Installation

This directory houses the install scripts for the packages on an Arch Linux
system. Some of these scripts simply call pacman to install the package, while
others are more complicated and require an AUR helper. They will fail with an
exit code of 1 if the AUR helper (set in ../../install.sh) isn't installed/in
the `$PATH`
