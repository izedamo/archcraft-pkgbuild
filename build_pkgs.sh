#!/usr/bin/env bash

## Dirs
DIR="$(pwd)"
PKGS=(`ls -p --hide={LICENSE,README.md,build_pkgs.sh,packages}`)
PKGDIR="$DIR/packages"

## Script Termination
exit_on_signal_SIGINT () {
    { printf "\n\n%s\n" "Script interrupted." 2>&1; echo; }
    exit 0
}

exit_on_signal_SIGTERM () {
    { printf "\n\n%s\n" "Script terminated." 2>&1; echo; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

# Build packages
build_pkgs () {
	local pkg

	{ echo; echo "Building Packages - "; echo; }
	for pkg in "${PKGS[@]}"; do
		echo "Building ${pkg}..."
		cd ${pkg} && makepkg -s
		mv *.pkg.tar.zst "$PKGDIR"
		ls --hide=PKGBUILD | xargs -d '\n' rm -r
		{ cd "$DIR"; echo; }
	done	
}

# Execute
build_pkgs
