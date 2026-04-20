### Dotfiles

Personal NixOS + home-manager configuration, with a chezmoi/doppler layer for
the few things that don't belong in the Nix store (SSH config tweaks, Claude
settings, secret-derived env files).

### Layout

- `flake.nix`, `modules/` — NixOS + home-manager configuration. Deep reference: [NIX.md](./NIX.md)
- `config/` — static dotfile sources imported by home-manager modules
- `pkgs/` — custom `callPackage` recipes
- `chezmoi/` — dotfiles kept out of the Nix store

### New host end-to-end

A full path from a blank NixOS install to a daily-driver machine.

#### 1. Bootstrap NixOS into the flake

1. Install NixOS (minimal or graphical ISO), boot, log in.
2. Get networking: `nmtui` for wireless, nothing for wired.
3. Enable flakes — the only edit you make to `/etc/nixos/`:
    ```nix
    # /etc/nixos/configuration.nix
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    ```
    Then `sudo nixos-rebuild switch`. Leave the hostname as whatever the
    installer set — the flake overrides it on activation.
4. Clone this repo:
    ```bash
    nix-shell -p git
    git clone <repo-url> ~/dotfiles && cd ~/dotfiles
    ```
5. Dump this machine's hardware config from the running hardware (never copy
   a stale checked-in file — UUIDs and kernel modules drift):
    ```bash
    mkdir -p modules/hosts/<hostname>
    sudo nixos-generate-config --show-hardware-config > modules/hosts/<hostname>/hardware-configuration.nix
    ```
6. Write `modules/hosts/<hostname>/default.nix` and register the host in
   `flake.nix`. Templates and the composition syntax live in
   [NIX.md → Adding a host](./NIX.md#adding-a-host).
7. Stage everything — flakes ignore untracked files:
    ```bash
    git add -A
    ```
8. Build as `boot` (keeps the current generation as default so you can roll
   back from the systemd-boot menu if the new one breaks), reboot, then
   switch for future changes. `nh` isn't on `PATH` yet, so run it one-off:
    ```bash
    nix run nixpkgs#nh -- os boot . -H <hostname>
    sudo reboot
    # after the machine comes up clean:
    nh os switch . -H <hostname>
    ```

After the first clean boot, `/etc/nixos/configuration.nix` is no longer
consulted — the flake owns everything.

#### 2. Secrets and non-Nix dotfiles

`just`, `direnv`, `doppler`, and `chezmoi` are installed by the home-manager
config, so they're on `PATH` once step 1 is complete.

1. `doppler login`
2. `doppler setup`
3. `doppler secrets substitute ./.envrc.tmpl > .envrc`
4. `direnv allow`
5. `chezmoi init --source $(pwd)`
6. `chezmoi apply`

### Daily use

```
just deploy        # nh os switch for the current host
just diff          # preview the nvd closure diff without activating
just update        # nix flake update
just upgrade       # flake update + deploy
```

### Chezmoi reference

```
chezmoi apply {-n}      # apply changes to ~ (dry run with -n)
chezmoi merge           # merge local edits back into chezmoi source
chezmoi update          # pull latest + apply
chezmoi add ~/.my_file  # manage a new file
chezmoi forget ~/.my_file
chezmoi managed         # list managed files
```

### Notes

- X11 forwarding over SSH: see [this guide](https://www.cyberciti.biz/faq/linux-unix-macos-fix-error-cant-open-display-null-with-ssh-xclip-command-in-headless/).
