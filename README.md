# Personal Nix Configs

My NixOS and Home Manager configurations for personal use.

## Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Git

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
   just test host <hostname>
   ```

1. Deploy a configuration:
   ```bash
   just deploy host <hostname>
   ```

## Structure

- `hosts/` - System configurations for different machines
- `modules/` - Shared configuration modules
- `config/vars.nix` - Global configuration variables

## Common Tasks

```bash
# Debug deployment issues
just debug host <hostname>

# Update all flake inputs
just up

# Update specific input
just upp i=home-manager

# View system history
just history

# Clean up old generations
just clean
```

When updating using `just up`, remember to redeploy affected hosts to apply changes using `just deploy host <hostname>` or similar.

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

