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
  options.signal.dev = with lib; {
  };
  imports = lib.signal.fs.listFiles ./src;
  config = {
    home.packages = with pkgs; [
      # debug
      strace
    ];
    manual = {
      html.enable = true;
      manpages.enable = true;
      json.enable = true;
    };
  };
}
