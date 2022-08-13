{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.dev;
in {
  options.dev = with lib; {
    enable = mkEnableOption "development environment configuration";
  };
  imports = [
    ./src/cache.nix
    ./src/direnv.nix
    ./src/git.nix
    ./src/lang.nix
    ./src/linker.nix
    ./src/neovim.nix
  ];
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # debug
      strace
    ];
  };
}
