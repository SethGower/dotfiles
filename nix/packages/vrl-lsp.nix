{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vrl-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "arshiyasolei";
    repo = "vrl-lsp";
    rev = "661e16f";
    hash = "sha256-txgtApKrJRNEVT3dV9FQcPaluCMmgBSSrKEzel+WbJA=";
  };

  cargoHash = "sha256-UQKvcXYT7h5qb11+7/5tuup50DUhQX2arTwcmPuyBpE=";

  meta = {
    description = "A Language Server Protocol Server for Vector Remap Language (VRL)";
    homepage = "https://github.com/arshiyasolei/vrl-lsp";
    license = lib.licenses.mit;
    maintainers = [];
  };
})
