{
  stdenv,
  lib,
  pkgs,
  affinityPath,
  wineUnwrapped,
}: pkg: name:
stdenv.mkDerivation {
  inherit name;
  src = ./.;
  nativeBuildInputs = [pkgs.makeWrapper];
  installPhase = ''
    makeWrapper ${lib.getExe' pkg name} $out/bin/${name} \
      --run 'export WINEPREFIX="${affinityPath}"' \
      --set LD_LIBRARY_PATH "${wineUnwrapped}/lib:$LD_LIBRARY_PATH" \
      --set WINESERVER "${lib.getExe' wineUnwrapped "wineserver"}" \
      --set WINELOADER "${lib.getExe' wineUnwrapped "wine"}" \
      --set WINEDLLPATH "${wineUnwrapped}/lib/wine" \
      --set WINE "${lib.getExe' wineUnwrapped "wine"}"
  '';
  meta.mainProgram = name;
}
