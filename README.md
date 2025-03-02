# NixOS Configuration with Hyprland

A clean NixOS configuration based on the [nixy](https://github.com/anotherhadi/nixy) setup, focused on a beautiful Hyprland environment.

## Structure

```
nixos-config/
├── flake.nix                 # Entry point, defines all machines and inputs
├── machines/                 # Machine-specific configurations
│   └── example-desktop/      # Example desktop configuration
│       ├── default.nix       # Main import file
│       ├── hardware.nix      # Hardware configuration
│       └── configuration.nix # System configuration
├── modules/                  # All modules with integrated home-manager configs
│   ├── core/                 # Essential system configurations
│   │   ├── default.nix       # Main core module
│   │   └── variables.nix     # Variables system
│   └── desktop/              # Desktop environments
│       └── hyprland/         # Hyprland environment
│           ├── default.nix   # Main module file
│           ├── system.nix    # System configuration for Hyprland
│           ├── home.nix      # Home-manager configuration
│           ├── hyprpanel.nix # Panel configuration
│           ├── stylix.nix    # Theme configuration
│           └── theme-vars.nix # Theme variables
└── secrets/                  # Secrets management (agenix)
```

## Features

- Clean and organized structure
- Beautiful Hyprland environment with animations and effects
- HyprPanel configured with matching themes
- Stylix integration for consistent theming across applications
- Easily customizable through variables system

## Usage

1. Copy this configuration to your own system (or clone the repository)
2. Modify `machines/example-desktop/configuration.nix` and `hardware.nix` to match your system
3. Build and activate the configuration:

```
sudo nixos-rebuild switch --flake .#example-desktop
```

## Customization

- Edit `machines/example-desktop/configuration.nix` to customize system settings
- Modify theme variables in `machines/example-desktop/configuration.nix` in the `var.theme` section
- Add additional modules as needed in `modules/`

## Credits

- Original inspiration from [nixy](https://github.com/anotherhadi/nixy)
- [Hyprland](https://github.com/hyprwm/Hyprland)
- [HyprPanel](https://github.com/Jas-SinghFSU/HyprPanel)
- [Stylix](https://github.com/danth/stylix) 