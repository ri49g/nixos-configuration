let
  # Define public keys for systems
  example-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."; # Replace with your actual key

  # Define keys for users
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."; # Replace with your actual key
in {
  # Define secrets and which keys can decrypt them
  # "secrets/encrypted/example-secret.age".publicKeys = [ example-desktop nixos ];
} 