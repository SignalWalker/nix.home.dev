{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev;
in {
  options = with lib; {};
  imports = [];
  config = {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      # NOTE :: this is read-only; fish automatically loads the direnv module regardless of this option
      # enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      nix-direnv.enable = true;
    };
    xdg.configFile = lib.mkIf config.programs.direnv.enable {
      "direnv/direnvrc" = {
        text = ''
          # strict_env

          : ''${XDG_CACHE_HOME:=$HOME/.cache}
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
              echo "''${direnv_layout_dirs[$PWD]:=$(
                  echo -n "$XDG_CACHE_HOME"/direnv/layouts/
                  echo -n "$PWD" | shasum | cut -d ' ' -f 1
              )}"
          }
        '';
        executable = true;
      };
    };
  };
}
