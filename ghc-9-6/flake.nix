{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
      in
      rec {
        packages = {
          cabal = pkgs.cabal-install;
          ghc = pkgs.haskell.packages.ghc96.ghcWithPackages (p:
            [ p.pipes ]);
          hls = pkgs.haskell-language-server.override {
            supportedGhcVersions = [ "96" ];
          };
        };
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = with packages; [ cabal ghc hls ];
          };
        };
      }
    );
}
