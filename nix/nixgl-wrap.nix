# Wraps a package's .desktop files to prepend nixGL to Exec lines.
# This is needed on non-NixOS systems where GPU apps need nixGL.
{ pkgs }:
pkg:
pkgs.symlinkJoin {
  name = "${pkg.name}-nixgl";
  paths = [ pkg ];
  meta = (pkg.meta or { }) // {
    mainProgram = pkg.meta.mainProgram or pkg.pname or pkg.name;
  };
  postBuild = ''
    # Replace symlinked .desktop files with patched copies
    if [ -d $out/share/applications ]; then
      for f in $out/share/applications/*.desktop; do
        [ -f "$f" ] || continue
        cp --remove-destination "$(readlink -f "$f")" "$f"
        sed -i 's|^Exec=|Exec=nixGL |' "$f"
        sed -i '/^TryExec=/d' "$f"
      done
    fi
  '';
}
