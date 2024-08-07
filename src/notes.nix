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
    home.packages = [
      pkgs.obsidian
    ];
    desktop.scratchpads = let
      notesDir = config.xdg.userDirs.extraConfig.XDG_NOTES_DIR;
    in {
      "Shift+N" = {
        criteria = {app_id = "scratch_notes";};
        resize = 83;
        startup = "kitty --class scratch_notes nvim +\"tcd ${notesDir}\" \"${notesDir}\"";
        systemdCat = true;
        automove = true;
        autostart = false;
      };
      "Shift+O" = {
        criteria = {
          app_id = "obsidian";
        };
        resize = 83;
        startup = "obsidian";
        systemdCat = true;
        automove = true;
        autostart = false;
      };
    };
  };
  meta = {};
}
