{ config
, pkgs
, lib
, ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev;
in
{
  options.signal.dev = with lib; { };
  imports = lib.signal.fs.path.listFilePaths ./src;
  config = {
    home.packages = with pkgs; [
      # debug
      strace
    ];
    manual = {
      html.enable = false;
      manpages.enable = false;
      json.enable = false;
    };
  };
}
