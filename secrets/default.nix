{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.agenix.nixosModules.default ];

  environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];

  # Define your age secrets here
  # age.secrets = { };
} 