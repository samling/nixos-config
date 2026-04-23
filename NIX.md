# NixOS Setup

This config uses the [dendritic pattern](https://github.com/mightyiam/dendritic):
each `.nix` file under `modules/` contributes to one or more named modules via
`flake.modules.<class>.<name>`, and many files merge into a small set of
class modules that hosts then compose.

## Repo structure

```
flake.nix                          # entry point — inputs + import-tree invocation
modules/
  meta/owner.nix                   # flake.meta.owner (username, state version, …) — single source of truth
  configurations/nixos.nix         # options.configurations.nixos + derives flake.nixosConfigurations

  home-manager/
    nixos.nix                      # NixOS-side wiring: each nixos class pulls its homeManager twin into
                                   #   home-manager.users.${owner}.imports
    identity.nix                   # homeManager.base: home.username / homeDirectory / stateVersion
    core.nix                       # homeManager.base: programs.home-manager.enable, direnv

  base/                            # → nixos.base (universal foundation)
    {nix,kernel,networking,locale,user,zsh,systemd}.nix

  cli/                             # → homeManager.base (CLI tools for every user)
    {core,git,zsh,tmux,neovim,dev-tools,nix-tools,kubernetes,media,lsd,bat,btop,ripgrep,command-snippets}.nix

  desktop/                         # → nixos.desktop + homeManager.desktop (graphical DE persona)
    {hyprland,hyprland-packages,hyprland-uwsm}.nix
    {audio,bluetooth,portal,regreet,disk,power,networking}.nix
    {theming,qt6ct,fonts,xdg}.nix
    {terminals,file-manager,browsers,chat,editors,media,remote-desktop}.nix
    {awww,rofi,quickshell,matugen,wallust,ghostty,clipboard}.nix
    security.nix                   # wireshark + littlesnitch (GUI workstation tools)

  dev/                             # → nixos.dev
    {docker,nix-ld}.nix

  hardware/                        # → nixos.laptop + homeManager.laptop
    asus.nix, keyd.nix, edid_mclk_fix.bin

  games/steam.nix                  # → nixos.games
  work/{teleport,vault}.nix        # → homeManager.work
  wsl/{wsl,x-forwarding}.nix       # → nixos.wsl
  tailscale.nix                    # → nixos.tailscale (opt-in per host)

  hosts/<hostname>/                # → configurations.nixos.<hostname>.module
    {imports,hostname,platform,state-version,…}.nix
    hardware-configuration.nix     # filtered out of import-tree, imported explicitly by imports.nix

config/                            # static dotfile sources referenced by home-manager modules
pkgs/                              # custom callPackage recipes
```

Every `.nix` under `modules/` is auto-discovered by
[`import-tree`](https://github.com/vic/import-tree) — add a file, its
`flake.modules.*` contributions are active on the next rebuild. Only
`hardware-configuration.nix` is filtered out of the tree; it's a plain NixOS
module that each host imports explicitly from its `imports.nix`.

## How it works

**Class modules.** A small set of names under `flake.modules.nixos.*` and
`flake.modules.homeManager.*` — the *classes*. Each class answers one question
about a host: "is this host a `desktop`? a `laptop`? running under `wsl`?".

**Files merge into classes.** Most feature files never declare a new named
module; they contribute to an existing class by name. `modules/desktop/audio.nix`
writes `flake.modules.nixos.desktop = { services.pipewire.enable = true; }`;
`modules/desktop/bluetooth.nix` writes `flake.modules.nixos.desktop = {
hardware.bluetooth.enable = true; }`; flake-parts merges them. Adding a
feature = dropping a file in the right folder, not editing an imports list.

**HM is wired into NixOS centrally.** `modules/home-manager/nixos.nix` declares
that every NixOS class pulls its homeManager twin into
`home-manager.users.${owner}.imports`:

```nix
flake.modules.nixos.base = {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username}.imports = [ config.flake.modules.homeManager.base ];
  };
};
flake.modules.nixos.desktop.home-manager.users.${username}.imports =
  [ config.flake.modules.homeManager.desktop ];
# …etc for laptop, work
```

Hosts therefore list **only NixOS classes**. Importing `nixos.desktop`
automatically pulls in `homeManager.desktop` for the owner. There is no
"second list" for HM modules in a host file.

**Owner is one value.** `modules/meta/owner.nix` is the single source of truth
for username, home directory, description, and state version. Every module
that needs the current user references `config.flake.meta.owner.*` instead of
hardcoding `"sboynton"`.

## Classes

| NixOS class | Means | Files |
|---|---|---|
| `base` | universal foundation — nix, user, locale, openssh, home-manager machinery | `base/`, `home-manager/nixos.nix` |
| `desktop` | graphical Linux DE (hyprland) | `desktop/` |
| `laptop` | laptop hardware (asus fan/edid, keyd) | `hardware/` |
| `wsl` | running under WSL | `wsl/` |
| `dev` | dev tooling (docker, nix-ld) | `dev/` |
| `games` | Steam | `games/` |
| `work` | work persona — wires homeManager.work | `home-manager/nixos.nix` |
| `tailscale` | tailscale daemon + firewall | `tailscale.nix` |

| HM class | Means | Files |
|---|---|---|
| `base` | CLI tools, shell, identity | `cli/`, `home-manager/{identity,core}.nix` |
| `desktop` | wayland stack, theming, GUI apps | `desktop/` |
| `laptop` | user-level laptop tools (asusctl, amdgpu_top, keyd mapper) | `hardware/` |
| `work` | teleport, vault | `work/` |

## Composition (hosts)

A host is a *directory* of small files under `modules/hosts/<name>/`, each
contributing to `configurations.nixos.<name>.module`. `modules/configurations/nixos.nix`
walks `config.configurations.nixos` and builds `flake.nixosConfigurations`
automatically — **no `flake.nix` edit is needed when adding a host.**

```nix
# modules/hosts/xen/imports.nix — chooses which personas this host has
{ config, ... }:
{
  configurations.nixos.xen.module = {
    imports = [ ./hardware-configuration.nix ] ++ (with config.flake.modules.nixos; [
      base desktop dev games laptop tailscale
    ]);
  };
}
```

```nix
# modules/hosts/xen/hostname.nix — one concern per file
{
  configurations.nixos.xen.module = {
    networking.hostName = "xen";
  };
}
```

```nix
# modules/hosts/xen/state-version.nix
{
  configurations.nixos.xen.module = {
    system.stateVersion = "25.11";
  };
}
```

All files in `modules/hosts/xen/` merge; there is no single default.nix. This
keeps hardware-configuration, boot loader, monitors, platform, etc. cleanly
separated and movable between hosts.

## Build flow

```mermaid
flowchart TB
    U([just deploy]):::entry
    U --> R[nh os switch . -H HOST]
    R --> F[[flake.nix<br/>import-tree ./modules]]:::flake

    F --> CFG[configurations/nixos.nix<br/>─────<br/>options.configurations.nixos<br/>derive flake.nixosConfigurations]:::flake

    F --> META[meta/owner.nix<br/>flake.meta.owner]:::always
    F --> HMW[home-manager/nixos.nix<br/>nixos.&lt;class&gt; → homeManager.&lt;class&gt;]:::always

    CFG --> HOST[hosts/HOST/ — merged<br/>─────<br/>imports · hostname · platform<br/>boot · state-version · host overrides]:::host

    HOST --> IMP[imports list<br/>NixOS classes only]:::group

    IMP --> baseC[base<br/>━━━<br/>base/*.nix]:::always
    IMP --> featC[feature classes<br/>━━━<br/>desktop · laptop · wsl · dev<br/>games · work · tailscale]:::feature

    baseC -. wires .-> hmB[homeManager.base<br/>cli/*.nix<br/>home-manager/{identity,core}.nix]:::always
    featC -. wires .-> hmF[homeManager.&lt;class&gt;<br/>desktop/*.nix · hardware/*.nix<br/>work/*.nix]:::feature

    featC -. imports .-> ih[inputs.hyprland]:::input
    featC -. imports .-> ia[inputs.asus-fan]:::input
    featC -. imports .-> iw[inputs.nixos-wsl]:::input

    classDef entry fill:#cfe,stroke:#393
    classDef flake fill:#fdc,stroke:#a60
    classDef host fill:#ffc,stroke:#aa0
    classDef group fill:#def,stroke:#36a
    classDef always fill:#efe,stroke:#393
    classDef feature fill:#fef,stroke:#a3a
    classDef input fill:#eee,stroke:#888,stroke-dasharray:4 2
```

**Reading it:**
- Every `.nix` under `modules/` is loaded by `import-tree`; they all contribute to the flake.
- Yellow host directory is the composition point — imports list + per-host overrides.
- Host files only list **NixOS classes**. HM content is carried automatically
  by the matching nixos class via `home-manager/nixos.nix`.
- Feature classes pull their flake inputs only when actually imported — WSL
  doesn't evaluate the hyprland input, xen doesn't evaluate nixos-wsl.

## Bootstrap (new machine)

Minimal path from a fresh NixOS install to this flake owning the system.
`nh ... -H <hostname>` selects which `nixosConfigurations.<name>` to build;
the selected entry's `networking.hostName` sets the running hostname on activation.

1. Install NixOS (minimal or graphical ISO) and log in.
2. Get networking: `nmtui` for wireless, nothing to do for wired.
3. Enable flakes — the only edit you'll make to `/etc/nixos/`:
   ```nix
   # /etc/nixos/configuration.nix
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```
   Then `sudo nixos-rebuild switch` once so system nix understands flakes.
4. Clone the repo:
   ```bash
   nix-shell -p git
   git clone <repo-url> ~/dotfiles && cd ~/dotfiles
   ```
5. Dump hardware config directly from running hardware (never copy the installer's file or a stale checked-in one — UUIDs and kernel modules drift):
   ```bash
   mkdir -p modules/hosts/<hostname>
   sudo nixos-generate-config --show-hardware-config > modules/hosts/<hostname>/hardware-configuration.nix
   ```
6. Write the host files (see [Adding a host](#adding-a-host) for templates).
   No `flake.nix` edit is required — `configurations.nixos.<name>` is
   auto-exposed as `flake.nixosConfigurations.<name>`.
7. If reinstalling over an old install, wipe leftover partitions so systemd GPT auto-discovery doesn't try to mount them and trigger a UUID wait-job:
   ```bash
   lsblk -f                         # find orphans not in fileSystems
   sudo wipefs -a /dev/<partition>  # for each orphan (old swap, old /home, etc.)
   ```
8. Stage all files — flakes only see git-tracked files, unstaged edits are invisible:
   ```bash
   git add -A
   ```
9. Sanity check the flake sees the hardware config:
   ```bash
   nix eval --json .#nixosConfigurations.<hostname>.config.fileSystems
   ```
10. Build as `boot` (not `switch`) and reboot — if the new generation breaks,
    the previous one is still the default entry and you can roll back from the
    systemd-boot menu. `nh` isn't on `PATH` yet, so invoke it one-off via `nix run`:
    ```bash
    nix run nixpkgs#nh -- os boot . -H <hostname>
    sudo reboot
    ```
11. After the machine comes up clean on the flake, `nh` is installed via
    home-manager. From then on:
    ```bash
    nh os switch . -H <hostname>   # or: just deploy
    ```

`/etc/nixos/configuration.nix` is no longer consulted after step 10 activates —
the flake owns everything.

## Adding a host

For when the repo is already set up and you want to provision another machine.

1. On the target machine, clone the repo and dump its hardware config:
   ```bash
   git clone <repo-url> ~/dotfiles && cd ~/dotfiles
   mkdir -p modules/hosts/<hostname>
   sudo nixos-generate-config --show-hardware-config > modules/hosts/<hostname>/hardware-configuration.nix
   ```

2. Write the host files. Split by concern — every file targets
   `configurations.nixos.<hostname>.module`, and they all merge. Typical
   laptop running hyprland:

   ```nix
   # modules/hosts/<hostname>/imports.nix
   { config, ... }:
   {
     configurations.nixos.<hostname>.module = {
       imports = [ ./hardware-configuration.nix ] ++ (with config.flake.modules.nixos; [
         base desktop laptop dev games tailscale
       ]);
     };
   }
   ```

   ```nix
   # modules/hosts/<hostname>/hostname.nix
   {
     configurations.nixos.<hostname>.module.networking.hostName = "<hostname>";
   }
   ```

   ```nix
   # modules/hosts/<hostname>/platform.nix
   {
     configurations.nixos.<hostname>.module.nixpkgs.hostPlatform = "x86_64-linux";
   }
   ```

   ```nix
   # modules/hosts/<hostname>/boot.nix
   {
     configurations.nixos.<hostname>.module.boot.loader = {
       systemd-boot.enable = true;
       efi.canTouchEfiVariables = true;
     };
   }
   ```

   ```nix
   # modules/hosts/<hostname>/state-version.nix
   {
     configurations.nixos.<hostname>.module.system.stateVersion = "25.11";
   }
   ```

   Per-host overrides (e.g. monitor layout) live in their own file too:

   ```nix
   # modules/hosts/<hostname>/monitor.nix
   { config, ... }:
   let
     inherit (config.flake.meta.owner) username;
   in
   {
     configurations.nixos.<hostname>.module.home-manager.users.${username}.wayland.windowManager.hyprland.settings.monitor = [
       ",preferred,auto,1.5"
     ];
   }
   ```

   For a WSL host, drop `hardware-configuration.nix` + boot loader (nixos-wsl
   handles both) and use a shorter imports list:

   ```nix
   # modules/hosts/<hostname>/imports.nix
   { config, ... }:
   {
     configurations.nixos.<hostname>.module = {
       imports = with config.flake.modules.nixos; [ base dev wsl work ];
     };
   }
   ```

3. No `flake.nix` edit is needed. `configurations.nixos.<hostname>` is
   automatically exposed as `flake.nixosConfigurations.<hostname>`.

4. Stage, preview, build as `boot`, reboot:
   ```bash
   git add -A
   just diff                                        # nvd closure diff
   nh os boot . -H <hostname>
   sudo reboot
   ```

   After the first clean boot, `just deploy` handles subsequent changes.

## Adding a feature module

1. Decide which class the feature belongs to. Is it universal (`base`)?
   Graphical (`desktop`)? Dev tooling (`dev`)? See the [classes table](#classes).
2. Create or edit a file in the matching folder. Just contribute to the
   class — no new named module needed:
   ```nix
   # modules/desktop/myapp.nix
   {
     flake.modules.homeManager.desktop = { pkgs, ... }: {
       home.packages = [ pkgs.myapp ];
     };
   }
   ```
   If the feature has both a NixOS and HM side, contribute to both in one file:
   ```nix
   {
     flake.modules.nixos.desktop = {
       services.myapp.enable = true;
     };
     flake.modules.homeManager.desktop = { pkgs, ... }: {
       home.packages = [ pkgs.myapp-cli ];
     };
   }
   ```
3. Done. Every host that imports the matching NixOS class automatically gets
   the new content on the next rebuild.

If the feature is a **new persona** (a new axis hosts opt into), define a new
class: pick a name, add a folder, and have `modules/home-manager/nixos.nix`
wire the HM twin if needed.

## Emergency mode / wait-job on a UUID

If boot hangs on `Timed out waiting for device /dev/disk/by-uuid/<UUID>`:

1. Compare the UUID against `blkid` — if it doesn't exist, find where it's referenced:
   ```bash
   nix eval --json .#nixosConfigurations.<hostname>.config.boot.kernelParams
   nix eval --json .#nixosConfigurations.<hostname>.config.boot.resumeDevice
   nix eval --json .#nixosConfigurations.<hostname>.config.swapDevices
   grep -r <UUID> /boot/loader/entries/    # old generations bake in stale resume=UUID=...
   ```
2. If it's only in old bootloader entries, delete the stale generations and regenerate:
   ```bash
   sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
   sudo /run/current-system/bin/switch-to-configuration boot
   ```
3. If nothing in the Nix config references it, it's GPT auto-discovery on an orphan partition — `wipefs` it (see Bootstrap step 7).

## Daily usage

Edit config, then apply:

```bash
git add -A
nh os switch . -H <hostname>   # or: just deploy
```

## Updating packages

```bash
nix flake update
nh os switch . -H <hostname>   # or: just upgrade (update + deploy)
```

## Garbage collection

```bash
nix-collect-garbage --delete-older-than 30d
nix-store --optimise
```
