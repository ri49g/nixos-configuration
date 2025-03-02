{ config, lib, pkgs, ... }: {
  imports = [
    # Hardware configuration
    ./hardware.nix
    
    # Machine-specific configuration
    ./configuration.nix
    
    # Core modules
    ../../modules/core
    
    # Desktop environment - Hyprland
    ../../modules/desktop/hyprland
  ];
} 