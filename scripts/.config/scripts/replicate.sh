#!/bin/sh
deps="git rsync"
for dep in $deps; do
	if [ "$(which $dep >/dev/null 2>&1)" ]; then
		printf "$0: error: could not find program \"$dep\" in PATH\n" 1>&2
		exit 1
	fi
done

tempfolder="/tmp/dots"
gitdir="$HOME/.config/.dot"
intalldir="$HOME/.config"
repo='git@gitlab.com:SethGower/dotfiles.git'
config='git --git-dir="$gitdir" --work-tree="$HOME"'

git clone --recursive --separate-git-dir="$gitdir" "$repo" "$tempfolder"
if ! $0; then
	printf "$0: error: failed cloning repository \"$repo\"\n" 1>&2
	printf "Do you have the appropriate permissions? Does the remote host know your key?\n"
	exit 2
fi
rsync -rvl --exclude ".git" $tempfolder/ $installdir/
rm -r $tempfolder
$config submodule update --init --recursive --remote
$config status.showUntrackedFiles no

printf "Creating Symlinks for files: "
for file in $(readfile -f $installdir/links/*.); do
	printf "    $file"
done

ln -sf $(readfile -f $installdir/links/*.) ~/

printf "$0: dotfiles set up successfully\n"
printf "Be sure and configure the following before issuing any commits:\n"
printf "    git config --global user.email\n"
printf "    git config --global user.name\n"
printf "It is recommended that you create GPG keys and sign commits"
exit 0
