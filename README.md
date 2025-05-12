# Nix configuration

Install Nix with:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Run the following commands:

```bash
sudo mkdir -p /etc/nix-darwin
sudo chown $(id -nu):$(id -ng) /etc/nix-darwin
cd /etc/nix-darwin
```

Clone the repository contents to this directory.

Install `nix-darwin`:

```bash
nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch
```

Apply changes to the system:

```bash
darwin-rebuild switch
```
