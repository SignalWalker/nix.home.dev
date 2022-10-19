{
  description = "Home manager configuration - development environment";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homelib = {
      url = github:signalwalker/nix.home.lib;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.alejandra.follows = "alejandra";
    };
    homebase = {
      url = github:signalwalker/nix.home.base;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.alejandra.follows = "alejandra";
      inputs.homelib.follows = "homelib";
    };
    # meta
    direnv = {
      url = github:direnv/direnv;
      flake = false;
    };
    nix-direnv = {
      url = github:nix-community/nix-direnv;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # editor
    neovim = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nvimpager = {
    #   url = github:lucc/nvimpager;
    #   inputs.neovim.follows = "neovim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nix
    statix = {
      # url = git+https://git.peppe.rs/languages/statix;
      url = github:nerdypepper/statix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rnix-lsp = {
      url = github:nix-community/rnix-lsp;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # rust
    mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }:
    with builtins; let
      homelib = inputs.homelib;
      std = nixpkgs.lib;
      hlib = homelib.lib;
      home = hlib.home;
      signal = hlib.signal;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) inputs.alejandra.packages;
      signalModules.default = {
        name = "home.dev.default";
        dependencies = signal.flake.set.toDependencies {
          flakes = inputs;
          filter = [];
          outputs = {
            mozilla.overlays = ["rust"];
          };
        };
        outputs = dependencies: {
          homeManagerModules = {lib, ...}: {
            imports = [
              ./home-manager.nix
            ];
            config = {};
          };
        };
      };
      homeConfigurations = home.configuration.fromFlake {
        flake = self;
        flakeName = "home.dev";
      };
      packages = home.package.fromHomeConfigurations self.homeConfigurations;
      apps = home.app.fromHomeConfigurations self.homeConfigurations;
    };
}
