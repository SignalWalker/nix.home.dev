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
    inputs = mkOption {
      type = types.attrsOf types.anything;
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./src;
  config = {
    home.packages = with pkgs; [
      # debug
      strace
    ];
    # TODO :: why are these disabled
    manual = {
      html.enable = false;
      manpages.enable = false;
      json.enable = false;
    };
  };
}
