default:
  @just --list

# List available hosts (assuming they're in the hosts directory)
list-hosts:
  @ls hosts/

# Test a specific host. Usage: $ just test host <host name>
test host:
  sudo nixos-rebuild test --flake .#{{host}}

# Deploy to a specific host. Usage: $ just deploy host <host name>
deploy host:
  sudo nixos-rebuild switch --flake .#{{host}}

# Upgrade a specific host. Usage: $ just deploy host <host name>
upgrade host:
  sudo nixos-rebuild --upgrade switch --flake .#{{host}}

# Debug deployment to a specific host. Usage: $ just debug host <host name>
debug host:
  sudo nixos-rebuild switch --flake .#{{host}} --show-trace --verbose

# List past NixOS generations
list-generations:
  sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Delete specific generations
delete-specific-generations generations:
  nix-collect-garbage --delete-generations #{{generations}}

# Delete all old generations. Can remove sudo to remove not remove system packages
delete-all-old-generations:
  sudo nix-collect-garbage --delete-old

# Update all inputs
update:
  nix flake update

# Update specific input. Usage: just update-input <input>
update-input input:
  nix flake update {{input}}

# Show Nix profile history
history:
  sudo nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

# Clean Nix profile history older than 7 days
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Run Nix garbage collection
gc:
  sudo nix-collect-garbage --delete-old
