{ pkgs, config, inputs, lib, ... }: 
let
  # Theme variables from the system configuration
  border-size = config.var.theme.border-size or 3;
  gaps-in = config.var.theme.gaps-in or 9;
  gaps-out = config.var.theme.gaps-out or 18;
  active-opacity = config.var.theme.active-opacity or 1;
  inactive-opacity = config.var.theme.inactive-opacity or 0.93;
  rounding = config.var.theme.rounding or 16;
  blur = config.var.theme.blur or true;
  keyboardLayout = config.var.keyboardLayout or "us";
  
  # Animation speed logic
  animationSpeed = config.var.theme.animation-speed or "fast";
  animationDuration = if animationSpeed == "slow" then
    "4"
  else if animationSpeed == "medium" then
    "2.5"
  else
    "1.5";
  borderDuration = if animationSpeed == "slow" then
    "10"
  else if animationSpeed == "medium" then
    "6"
  else
    "3";
in {
  imports = [
    # Import HyprPanel configuration
    ./hyprpanel.nix
  ];

  home.packages = with pkgs; [
    # Wayland utilities
    hyprshot             # Screenshot utility for Hyprland
    hyprpicker           # Color picker
    swappy               # Screenshot editor
    wf-recorder          # Screen recorder
    wlr-randr            # Screen layout manager
    wl-clipboard         # Command-line clipboard
    wayland-utils        # Wayland utilities
    wayland-protocols    # Wayland protocols
    brightnessctl        # Brightness control
    
    # Theming
    gnome-themes-extra
    
    # Libraries & development utilities
    libva
    glib
    direnv
    meson
  ];

  # Configure Hyprland wayland compositor
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    
    # Add Hyprspace plugin for overview effect
    plugins = lib.optional (inputs ? hyprspace) 
      [ inputs.hyprspace.packages.${pkgs.system}.Hyprspace ];
    
    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";
      
      exec-once = [
        "dbus-update-activation-environment --systemd --all"
      ];
      
      # Monitor configuration - replace with your actual monitors
      monitor = [
        ",preferred,auto,1"
      ];
      
      # Environment variables for wayland
      env = [
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "NIXOS_OZONE_WL,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "__GL_GSYNC_ALLOWED,0"
        "__GL_VRR_ALLOWED,0"
        "DIRENV_LOG_FORMAT,"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
      ];
      
      # Cursor settings
      cursor = {
        no_hardware_cursors = true;
      };
      
      # General settings
      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        layout = "master";
      };
      
      # Window decoration settings
      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled = if blur then "true" else "false";
          size = 16;
        };
      };
      
      # Window layout settings
      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
      };
      
      # Gestures
      gestures = { workspace_swipe = true; };
      
      # Miscellaneous settings
      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };
      
      # Window rules
      windowrulev2 = [
        "float, tag:modal"
        "pin, tag:modal" 
        "center, tag:modal"
      ];
      
      # Layer rules
      layerrule = [
        "noanim, launcher"
        "noanim, ^ags-.*"
      ];
      
      # Input settings
      input = {
        kb_layout = keyboardLayout;
        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0.5;
        repeat_delay = 300;
        repeat_rate = 50;
        numlock_by_default = true;
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
        };
      };
      
      # Animations
      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
        ];
        
        animation = [
          "windows, 1, ${animationDuration}, md3_decel, popin 60%"
          "windowsIn, 1, ${animationDuration}, md3_decel, popin 60%"
          "windowsOut, 1, ${animationDuration}, md3_accel, popin 60%"
          "border, 1, ${borderDuration}, default"
          "fade, 1, ${animationDuration}, md3_decel"
          "layersIn, 1, ${animationDuration}, menu_decel, slide"
          "layersOut, 1, ${animationDuration}, menu_accel"
          "fadeLayersIn, 1, ${animationDuration}, menu_decel"
          "fadeLayersOut, 1, ${animationDuration}, menu_accel"
          "workspaces, 1, ${animationDuration}, menu_decel, slide"
          "specialWorkspace, 1, ${animationDuration}, md3_decel, slidevert"
        ];
      };
      
      # Key bindings
      bind = [
        "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, Q, killactive,"
        "$mod, T, togglefloating,"
        "$mod, F, fullscreen"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$shiftMod, up, focusmonitor, -1"
        "$shiftMod, down, focusmonitor, 1"
        "$shiftMod, left, layoutmsg, addmaster"
        "$shiftMod, right, layoutmsg, removemaster"
        
        # Screenshot bindings
        "$mod, PRINT, exec, hyprshot -m region"
        ", PRINT, exec, hyprshot -m output"
        
        # Workspace bindings (1-9)
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        
        # Move window to workspace
        "$shiftMod, 1, movetoworkspace, 1"
        "$shiftMod, 2, movetoworkspace, 2"
        "$shiftMod, 3, movetoworkspace, 3"
        "$shiftMod, 4, movetoworkspace, 4"
        "$shiftMod, 5, movetoworkspace, 5"
        "$shiftMod, 6, movetoworkspace, 6"
        "$shiftMod, 7, movetoworkspace, 7"
        "$shiftMod, 8, movetoworkspace, 8"
        "$shiftMod, 9, movetoworkspace, 9"
      ];
    };
  };

  # Add hyprspace plugin bindings if available
  wayland.windowManager.hyprland.settings = lib.mkIf (inputs ? hyprspace) {
    plugin.overview = { autoDrag = false; };
    bind = [
      "$mod, TAB, overview:toggle" # Overview
    ];
  };

  # Enable hyprpaper for wallpaper
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
    };
  };

  # Ensure the session target is properly set
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
} 