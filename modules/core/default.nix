{ config, lib, pkgs, ... }: {
  imports = [
    ./variables.nix
  ];

  config = {
    # Basic system configuration
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          consoleMode = "auto";
          configurationLimit = 10;
        };
      };
      kernelPackages = pkgs.linuxPackages_latest;
      
      # Silent boot
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "vga=current"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };

    # Nix settings
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };
      gc = {
        automatic = lib.mkDefault true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };

    # Basic environment configuration
    environment = {
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        XDG_DATA_HOME = "$HOME/.local/share";
      };
      systemPackages = with pkgs; [
        git
        curl
        wget
        fd
        ripgrep
        gnumake
        gcc
        jq
        unzip
        zip
      ];
    };

    # Set zsh as default shell
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Documentation settings for faster rebuilding
    documentation = {
      enable = true;
      doc.enable = false;
      man.enable = true;
      dev.enable = false;
      info.enable = false;
      nixos.enable = false;
    };

    # Don't change this
    system.stateVersion = "24.05";
  };
} 