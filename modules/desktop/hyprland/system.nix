{ pkgs, config, ... }: {
  # Enable XDG portal
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.libsForQt5.xdg-desktop-portal-kde
    ];
    config.hyprland = { default = [ "hyprland" "gtk" ]; };
  };

  # System packages needed for Hyprland
  environment.systemPackages = with pkgs; [
    hyprland-qtutils
    xdg-utils
    libinput
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6ct
    gnome.gnome-keyring
  ];

  # Enable basic services needed for Hyprland
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = config.var.keyboardLayout or "us";
        variant = "";
      };
    };
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
  };

  # Input settings
  services.libinput.enable = true;
  console.keyMap = config.var.keyboardLayout or "us";

  # Enables GNOME stuff
  programs.dconf.enable = true;

  # Don't shutdown when power button is short-pressed
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';
} 