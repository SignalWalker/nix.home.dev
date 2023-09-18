{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
  cfg = config.signal.dev.git;
  crane = config.signal.dev.inputs.crane.lib.${pkgs.system};
in {
  options.signal.dev.git = with lib; {
    enable = (mkEnableOption "Git configuration") // {default = true;};
    onefetch = {
      src = mkOption {
        type = types.path;
      };
    };
  };
  imports = lib.signal.fs.path.listFilePaths ./git;
  config = lib.mkIf (cfg.enable) {
    programs.onefetch = {
      enable = false;
      # package = crane.buildPackage {
      #   src = crane.cleanCargoSource cfg.onefetch.src;
      #   nativeBuildInputs = with pkgs; [cmake installShellFiles pkg-config];
      #   buildInputs = with pkgs; [zstd];
      # };
    };
    home.packages = with pkgs; [
      # gitoxide
      gh
      glab
    ];
    # home.shellAliases = {
    #   gx = "gix"; # really don't like the default gitoxide command
    # };
    programs.git = {
      enable = true;
      userName = "Ash Walker";
      userEmail = config.signal.email.git;
      lfs.enable = true;
      signing = {
        key = lib.mkDefault null;
        gpgPath =
          if config.programs.gpg.enable
          then "${config.programs.gpg.package}/bin/gpg"
          else "/usr/bin/gpg";
        signByDefault = true;
      };
      ignores = [
        "/.lnvim.*"
        "/.envrc"
      ];
      extraConfig = {
        core = {
          autocrlf = "input";
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
        merge = {
          conflictStyle = "diff3";
        };
      };
    };
  };
}
