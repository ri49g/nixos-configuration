{ config, lib, pkgs, ... }: {
  # Set variables for this system
  var = {
    hostname = "example-desktop";
    username = "nixos";
    keyboardLayout = "us";
    
    # The location for weather and time
    location = "New York";
    timeZone = "America/New_York";
    defaultLocale = "en_US.UTF-8";
    
    # Modify the theme if desired
    theme = {
      # Inherit default theme settings
      imports = [ (import ../../modules/desktop/hyprland/theme-vars.nix) ];
      
      # Override specific settings as needed
      rounding = 12;
      gaps-in = 8;
      gaps-out = 16;
      
      # Bar configuration 
      bar = {
        position = "top";
        transparent = true;
        floating = true;
        transparentButtons = true;
      };
    };
  };
  
  # Configure networking
  networking = {
    hostName = config.var.hostname;
    networkmanager.enable = true;
  };
  
  # Set timezone and locale
  time.timeZone = config.var.timeZone;
  i18n.defaultLocale = config.var.defaultLocale;

  # Create the user account
  users.users.${config.var.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "changeme";  # Remember to change this after first login
  };
  
  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;  # Disable pulseaudio in favor of pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
} 