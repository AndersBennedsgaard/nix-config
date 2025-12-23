default:
  @just --list

# List available hosts (assuming they're in the hosts directory)
list-hosts:
  @ls hosts/

# Test a specific host with dry-run. Usage: $ just dry-run <host name>
dry-run host:
  #!/usr/bin/env bash
  if nix eval .#darwinConfigurations.{{host}}.config.networking.hostName &>/dev/null; then
    nix build .#darwinConfigurations.{{host}}.system --dry-run
  else
    sudo nixos-rebuild dry-run --flake .#{{host}}
  fi

# Test a specific host. Usage: $ just test <host name>
test host:
  #!/usr/bin/env bash
  if nix eval .#darwinConfigurations.{{host}}.config.networking.hostName &>/dev/null; then
    darwin-rebuild check --flake .#{{host}}
  else
    sudo nixos-rebuild test --flake .#{{host}}
  fi

# Deploy to a specific host. Usage: $ just deploy <host name>
deploy host:
  #!/usr/bin/env bash
  if nix eval .#darwinConfigurations.{{host}}.config.networking.hostName &>/dev/null; then
    darwin-rebuild switch --flake .#{{host}}
  else
    sudo nixos-rebuild switch --flake .#{{host}}
  fi

# Upgrade a specific host. Usage: $ just upgrade <host name>
upgrade host:
  #!/usr/bin/env bash
  if nix eval .#darwinConfigurations.{{host}}.config.networking.hostName &>/dev/null; then
    darwin-rebuild switch --flake .#{{host}} --recreate-lock-file
  else
    sudo nixos-rebuild --upgrade switch --flake .#{{host}}
  fi

# Debug deployment to a specific host. Usage: $ just debug <host name>
debug host:
  #!/usr/bin/env bash
  if nix eval .#darwinConfigurations.{{host}}.config.networking.hostName &>/dev/null; then
    darwin-rebuild switch --flake .#{{host}} --show-trace --verbose
  else
    sudo nixos-rebuild switch --flake .#{{host}} --show-trace --verbose
  fi

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
