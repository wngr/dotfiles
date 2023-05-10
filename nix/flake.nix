{
  description = "wngr dev setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils = {
      url = "github:numtide/flake-utils";
    };
  };
  
  outputs = { self, nixpkgs, utils, rust-overlay }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { 
          inherit system overlays;
          config.allowUnfree = true;
        };
      in with pkgs;
      {
        devShells = {
          default = mkShell {
            buildInputs = [
              git
              cargo-watch
              cargo-flamegraph
              cargo-udeps
              (rust-bin.stable.latest.default.override {
                # required for rust-analyzer
                extensions = [
                  "rust-src"
                  "cargo"
                  "clippy"
                  "rustc"
                  "rustfmt"
                ];
              })
              neovim
              nodejs-19_x
            ]
            ++ lib.optionals stdenv.isDarwin [
              darwin.apple_sdk.frameworks.Security
            ]
            ++ lib.optionals stdenv.isLinux [
            ];

            nativeBuildInputs = [
              pkg-config
            ];

            shellHook = ''
              export EDITOR=nvim;
              export RUST_LOG=info;
            '';
          };
      };
    }
  );
}

