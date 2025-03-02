{ config, lib, pkgs, ... }: {
  imports = [
    # System configuration for Hyprland
    ./system.nix
    
    # Stylix theme configuration
    ./stylix.nix
  ];

  # Set the theme configuration for Hyprland environment
  var.theme = import ./theme-vars.nix;

  # Setup home-manager integration for the Hyprland environment
  home-manager.users.${config.var.username or "nixos"} = { pkgs, ... }: {
    imports = [
      # Home configuration for Hyprland
      ./home.nix
    ];
    
    # Basic terminal emulator as a fallback
    programs.kitty = {
      enable = true;
      settings = {
        window_padding_width = 12;
        font_size = 12;
        enable_audio_bell = false;
        background_opacity = "0.95";
      };
    };
  };
} 