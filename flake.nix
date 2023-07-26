{
  description = "Home manager configuration - development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # meta
    direnv = {
      url = "github:direnv/direnv";
      flake = false;
    };
    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # editor
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ashvim = {
      url = "github:signalwalker/cfg.neovim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.neovim.follows = "neovim";
    };
    ashmacs = {
      url = "github:signalwalker/cfg.emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix
    statix = {
      # url = "git+https://git.peppe.rs/languages/statix";
      url = "github:nerdypepper/statix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # rust
    mozilla = {
      url = "github:mozilla/nixpkgs-mozilla";
    };
    # git
    onefetch = {
      url = "github:o2sh/onefetch";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }:
    with builtins; let
      std = nixpkgs.lib;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      homeManagerModules.default = {lib, ...}: {
        imports = [
          inputs.ashvim.homeManagerModules.default
          inputs.ashmacs.homeManagerModules.default
          ./home-manager.nix
        ];
        config = {
          signal.dev.inputs = inputs;
          signal.dev.git.onefetch.src = inputs.onefetch;
        };
      };
    };
}
