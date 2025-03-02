{ inputs, config, pkgs, lib, ... }:
let
  transparentButtons = config.var.theme.bar.transparentButtons or false;
  
  # Get colors from stylix
  accent = "#${config.lib.stylix.colors.base0D}";
  accent-alt = "#${config.lib.stylix.colors.base03}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  
  # Get font from stylix
  font = "${config.stylix.fonts.serif.name}";
  fontSize = "${toString config.stylix.fonts.sizes.desktop}";
  
  # Get theme variables
  rounding = config.var.theme.rounding or 16;
  border-size = config.var.theme.border-size or 3;
  gaps-out = config.var.theme.gaps-out or 18;
  gaps-in = config.var.theme.gaps-in or 9;
  
  # Bar settings
  floating = config.var.theme.bar.floating or true;
  transparent = config.var.theme.bar.transparent or false;
  position = config.var.theme.bar.position or "top";
  
  # Location for weather if available
  location = config.var.location or "Paris";
in {
  imports = lib.optional (inputs ? hyprpanel) inputs.hyprpanel.homeManagerModules.hyprpanel;

  # Create helper scripts for hyprpanel
  home.packages = let
    hyprpanel-toggle = pkgs.writeShellScriptBin "hyprpanel-toggle" ''
      hyprpanel toggleWindow bar-0
      hyprpanel toggleWindow bar-1
      hyprpanel toggleWindow bar-2
      hyprpanel toggleWindow bar-3
    '';

    hyprpanel-hide = pkgs.writeShellScriptBin "hyprpanel-hide" ''
      status=$(hyprpanel isWindowVisible bar-0)
      if [[ $status == "true" ]]; then
        hyprpanel toggleWindow bar-0
      fi
      status=$(hyprpanel isWindowVisible bar-1)
      if [[ $status == "true" ]]; then
        hyprpanel toggleWindow bar-1
      fi
    '';

    hyprpanel-show = pkgs.writeShellScriptBin "hyprpanel-show" ''
      status=$(hyprpanel isWindowVisible bar-0)
      if [[ $status == "false" ]]; then
        hyprpanel toggleWindow bar-0
      fi
      status=$(hyprpanel isWindowVisible bar-1)
      if [[ $status == "false" ]]; then
        hyprpanel toggleWindow bar-1
      fi
    '';

    hyprpanel-reload = pkgs.writeShellScriptBin "hyprpanel-reload" ''
      [ $(pgrep "hyprpanel") ] && pkill hyprpanel
      hyprctl dispatch exec hyprpanel
    '';
  in [ hyprpanel-toggle hyprpanel-reload hyprpanel-hide hyprpanel-show ];

  # Add HyprPanel configuration if the module is available
  programs.hyprpanel = lib.mkIf (inputs ? hyprpanel) {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
    overlay.enable = true;
    
    # Bar layout configuration
    layout = {
      "bar.layouts" = {
        "*" = {
          "left" = [ "dashboard" "workspaces" "windowtitle" ];
          "middle" = [ "media" "cava" ];
          "right" = [
            "systray"
            "volume"
            "bluetooth"
            "battery"
            "network"
            "clock"
            "notifications"
          ];
        };
      };
    };
    
    # Override hyprpanel settings with our theme
    override = {
      "theme.font.name" = "${font}";
      "theme.font.size" = "${fontSize}px";
      "theme.bar.outer_spacing" = "${if floating && transparent then "0" else "8"}px";
      "theme.bar.buttons.y_margins" = "${if floating && transparent then "0" else "8"}px";
      "theme.bar.buttons.spacing" = "0.3em";
      "theme.bar.buttons.radius" = "${if transparent then toString rounding else toString (rounding - 8)}px";
      "theme.bar.floating" = "${if floating then "true" else "false"}";
      "theme.bar.buttons.padding_x" = "0.8rem";
      "theme.bar.buttons.padding_y" = "0.4rem";
      "theme.bar.buttons.workspaces.hover" = "${accent-alt}";
      "theme.bar.buttons.workspaces.active" = "${accent}";
      "theme.bar.buttons.workspaces.available" = "${accent-alt}";
      "theme.bar.buttons.workspaces.occupied" = "${accent-alt}";
      "theme.bar.margin_top" = "${if position == "top" then toString (gaps-in * 2) else "0"}px";
      "theme.bar.margin_bottom" = "${if position == "top" then "0" else toString (gaps-in * 2)}px";
      "theme.bar.margin_sides" = "${toString gaps-out}px";
      "theme.bar.border_radius" = "${toString rounding}px";
      "bar.launcher.icon" = "";
      "theme.bar.transparent" = "${if transparent then "true" else "false"}";
      "bar.workspaces.show_numbered" = false;
      "bar.workspaces.workspaces" = 5;
      "bar.workspaces.hideUnoccupied" = false;
      "bar.windowtitle.label" = true;
      "bar.volume.label" = false;
      "bar.network.truncation_size" = 12;
      "bar.bluetooth.label" = false;
      "bar.clock.format" = "%a %b %d  %I:%M %p";
      "bar.notifications.show_total" = true;
      "theme.notification.border_radius" = "${toString rounding}px";
      "theme.osd.enable" = true;
      "theme.osd.orientation" = "vertical";
      "theme.osd.location" = "left";
      "theme.osd.radius" = "${toString rounding}px";
      "theme.osd.margins" = "0px 0px 0px 10px";
      "theme.osd.muted_zero" = true;
      "menus.clock.weather.location" = "${location}";
      "menus.clock.weather.unit" = "metric";
      "menus.dashboard.powermenu.confirmation" = false;
      
      # Dashboard shortcuts
      "menus.dashboard.shortcuts.left.shortcut1.icon" = "";
      "menus.dashboard.shortcuts.left.shortcut1.command" = "${pkgs.firefox}/bin/firefox";
      "menus.dashboard.shortcuts.left.shortcut1.tooltip" = "Firefox";
      "menus.dashboard.shortcuts.left.shortcut2.icon" = "";
      "menus.dashboard.shortcuts.left.shortcut2.command" = "${pkgs.kitty}/bin/kitty";
      "menus.dashboard.shortcuts.left.shortcut2.tooltip" = "Terminal";
      "menus.dashboard.shortcuts.right.shortcut1.icon" = "";
      "menus.dashboard.shortcuts.right.shortcut1.command" = "hyprpicker -a";
      "menus.dashboard.shortcuts.right.shortcut1.tooltip" = "Color Picker";
      
      # Theme colors
      "theme.bar.buttons.background" = "${(if transparent then background else background-alt) + (if transparentButtons then "00" else "")}";
      "theme.bar.buttons.icon" = "${accent}";
      "theme.bar.buttons.notifications.background" = "${background-alt}";
      "theme.bar.buttons.hover" = "${background}";
      "theme.bar.buttons.notifications.hover" = "${background}";
      "theme.bar.buttons.notifications.total" = "${accent}";
      "theme.bar.buttons.notifications.icon" = "${accent}";
      "theme.notification.background" = "${background-alt}";
      "theme.notification.actions.background" = "${accent}";
      "theme.notification.actions.text" = "${foreground}";
      "theme.notification.label" = "${accent}";
      "theme.notification.border" = "${background-alt}";
      "theme.notification.text" = "${foreground}";
      "theme.notification.labelicon" = "${accent}";
      "theme.osd.bar_color" = "${accent}";
      "theme.osd.bar_overflow_color" = "${accent-alt}";
      "theme.osd.icon" = "${background}";
      "theme.osd.icon_container" = "${accent}";
      "theme.osd.label" = "${accent}";
      "theme.osd.bar_container" = "${background-alt}";
      "theme.bar.menus.menu.media.background.color" = "${background-alt}";
      "theme.bar.menus.menu.media.card.color" = "${background-alt}";
      "theme.bar.menus.menu.media.card.tint" = 90;
      "bar.customModules.updates.pollingInterval" = 1440000;
      "bar.media.show_active_only" = true;
      "theme.bar.location" = "${position}";
      "bar.workspaces.numbered_active_indicator" = "color";
      "bar.workspaces.monitorSpecific" = false;
      "bar.workspaces.applicationIconEmptyWorkspace" = "";
      "bar.workspaces.showApplicationIcons" = true;
      "bar.workspaces.showWsIcons" = true;
      "theme.bar.dropdownGap" = "4.5em";
      "theme.bar.menus.shadow" = "${if transparent then "0 0 0 0" else "0px 0px 3px 1px #16161e"}";
      "bar.customModules.cava.showIcon" = false;
      "bar.customModules.cava.stereo" = true;
      "bar.customModules.cava.showActiveOnly" = true;
    };
  };
  
  # Add keybinding for hyprpanel-toggle
  wayland.windowManager.hyprland.settings = lib.mkIf (inputs ? hyprpanel) {
    bind = [ "$shiftMod, T, exec, hyprpanel-toggle" ];
  };
} 