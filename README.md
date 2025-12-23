# Personal Nix Configs

My NixOS and Home Manager configurations for personal use.

## Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Git

## Mac Setup (not tested)

For Mac hosts using nix-darwin, first install the Darwin rebuild CLI:

```bash
nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch
```

After this initial setup, the standard `just` commands will work as expected.

## Getting Started

1. Clone this repository:
   ```bash
   git clone git@github.com:AndersBennedsgaard/nix-config.git
   cd nix-config
   ```

1. Enter the Nix shell for development tools:
   ```bash
   nix-shell
   ```

1. List available hosts:
   ```bash
   just list-hosts
   ```

1. Test a configuration (non-destructive):
   ```bash
   just test <hostname>
   ```

1. Deploy a configuration:
   ```bash
   just deploy <hostname>
   ```

## Structure

- `hosts/` - System configurations for different machines
- `modules/` - Shared configuration modules
- `config/vars.nix` - Global configuration variables

## Common Tasks

```bash
# Dry run a deployment (see changes without applying)
just dry-run <hostname>

# Debug deployment issues
just debug <hostname>

# Upgrade a host (with lock file recreation)
just upgrade <hostname>

# Update all flake inputs
just update

# Update specific input. <input> can be the name of any flake input, e.g., nixpkgs, home-manager, etc.
just update-input <input>

# Show system history
just history

# List past NixOS generations
just list-generations

# Clean up old generations (older than 7 days)
just clean

# Run garbage collection
just gc

# Delete specific generations
just delete-specific-generations <generations>

# Delete all old generations
just delete-all-old-generations

# Start Nix REPL
just repl
```

When updating using `just update`, remember to redeploy affected hosts to apply changes using `just deploy <hostname>` or similar.

## Development

### Git Hooks

This repository uses pre-commit hooks to ensure code quality. To set up the git hooks:

```bash
# Install pre-commit hooks
pre-commit install
```

This will install the following hooks:
- Alejandra: Automatically formats Nix files according to project standards

The pre-commit hooks will run automatically on commit. You can also manually run them:

```bash
# Run on all files
pre-commit run --all-files

# Run specific hook
pre-commit run alejandra --all-files
```

