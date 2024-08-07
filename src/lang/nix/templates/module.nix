{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options = with lib; {};
  disabledModules = [];
  imports = [];
  config = {
    warnings = ["warning"];
    assertions = [
      {
        assertion = false;
        message = "assertion";
      }
    ];
  };
  meta = {};
}
