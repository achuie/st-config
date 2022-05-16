{
  description = "Custom st build";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
  let
    fetchpatch = nixpkgs.legacyPackages.x86_64-linux.fetchpatch;
    writeText= nixpkgs.legacyPackages.x86_64-linux.writeText;
  in {
    packages.x86_64-linux.st =
      nixpkgs.legacyPackages.x86_64-linux.st.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ nixpkgs.legacyPackages.x86_64-linux.harfbuzz ];
        patches = [
          (fetchpatch {
            url = "http://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.5.diff";
            sha256 = "108h30073yb8nm9x04x7p39di8syb8f8k386iyy2mdnfdxh54r04";
          })
          (fetchpatch {
            url = "http://st.suckless.org/patches/ligatures/0.8.4/st-ligatures-boxdraw-20210824-0.8.4.diff";
            sha256 = "1y9ab758nnknsjff3gdda4v2qhx36inlb9dvhbpayr6d81g6l587";
          })
        ];

        configFile = writeText "config.def.h" (builtins.readFile ./config.h);
        postPatch = oldAttrs.postPatch + "cp ${configFile} config.def.h";
      });

    defaultPackage.x86_64-linux = self.packages.x86_64-linux.st;
  };
}
