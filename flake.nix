{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {self, nixpkgs, ...}: let
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages.${system}.extend overlay;
    
    overlay = self: super: {
      haskell = super.haskell // {
        packageOverrides = self: super: {
          test-inline-c = self.callCabal2nix "test-inline-c" ./. { };
        };
      };
    };

    ghc = "ghc963";

  in {
    packages.${system} = rec { 
      default = test-inline-c;
      test-inline-c = pkgs.haskell.packages.${ghc}.test-inline-c;

      test-inline-c-shell = default.env.overrideAttrs (oldAttrs: {
        name = "test-inline-c";

        buildInputs = oldAttrs.buildInputs ++ (with pkgs; [
          cabal-install
          haskell-language-server
          hlint
          nil
        ]);
      });
    };

    devShells.${system}.default = self.packages.${system}.test-inline-c-shell;

    overlays.default = overlay;
  };
}

