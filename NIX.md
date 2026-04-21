# NixOS Setup

This config uses the [dendritic pattern](https://renatogarcia.blog.br/posts/a-simple-nix-dendritic-config.html):
every `.nix` file under `modules/` declares one or more reusable modules via
`flake.modules.<class>.<name>`, and `flake.nix` composes them into hosts.

## Repo structure

```
flake.nix                                    # entry point — inputs; hands each host module to nixosSystem
modules/base/                                # reusable feature modules
  system.nix                                 #   flake.modules.nixos.base (OS baseline, imports home-manager)
  desktop.nix                                #   nixos.desktop + homeManager.desktop (imports ghostty)
  dev.nix                                    #   nixos.docker + nixos.nix-ld
  games.nix                                  #   flake.modules.nixos.games
  work.nix                                   #   flake.modules.homeManager.work
  wsl.nix                                    #   flake.modules.nixos.wsl
  cli/                                       # Collection — aggregator lives in default.nix, parts are siblings
    default.nix                              #   flake.modules.homeManager.cli (bundle)
    {core,git,zsh,neovim,tmux,…}.nix         #   per-tool HM modules
  wayland/                                   # Collection for generic wayland tools
    default.nix                              #   flake.modules.homeManager.wayland (bundle + clipboard daemons as systemd user services)
    {awww,matugen,quickshell,rofi}.nix       #   generic wayland tools composed by wayland/default.nix
    hyprland/                                # Nested collection for hyprland-specific modules
      default.nix                            #     flake.modules.homeManager.hyprland (bundle)
      core.nix                               #     enable + hypr-* packages + plugins + uwsm env + xwayland default
      {theme,keywords,input,layout}.nix      #     settings (palette, $vars, input/gestures, general/decoration/animations)
      {autostart,keybinds,plugins,windowrules}.nix
  terminals/ghostty.nix                      #   flake.modules.homeManager.ghostty
  hardware/{asus,keyd}.nix
  security/littlesnitch.nix
modules/hosts/<hostname>/
  default.nix                                # flake.modules.nixos.<hostname> — the composition aggregator for this host
  hardware-configuration.nix                 # regenerated via nixos-generate-config
modules/users/<user>/default.nix             # flake.modules.homeManager.<user> (identity)
config/                                      # static dotfile sources (hypr scripts, nvim, tmux, zsh, …)
pkgs/                                        # custom callPackage recipes
```

**Convention:** a directory under `modules/base/` means a collection. Its
`default.nix` is the aggregator module (`flake.modules.<class>.<name>`); the
sibling `.nix` files are the parts it composes. Standalone feature modules
(`desktop.nix`, `dev.nix`, `wsl.nix`) stay as single files — no collection needed.

Every `.nix` under `modules/` is auto-discovered by
[`import-tree`](https://github.com/vic/import-tree) — drop a new file in and
its `flake.modules.*` declarations are available on next rebuild. `hardware-configuration.nix`
files are filtered out of the tree (they're plain NixOS modules, not flake-parts modules)
and are imported by their host's `default.nix` directly.

Modules have a **class** (`nixos`, `homeManager`, later `darwin`) and a **name**.
One file can declare multiple classes — `desktop.nix` declares both
`flake.modules.nixos.desktop` (system-level: portal, hyprland service, audio)
and `flake.modules.homeManager.desktop` (user-level: GUI apps, theming). When
a host imports `desktop` for nixos, it also imports `desktop` for homeManager —
no platform subdirs needed.

## Composition

Hosts are **composed**, not gated. The host's own module file
(`modules/hosts/<hostname>/default.nix`) is the composition aggregator: it
declares which feature modules to pull in via its `imports` list, sets the
hostname / boot loader / per-host overrides, and pulls home-manager modules
into `home-manager.users.<user>.imports`. Unlisted modules are never evaluated.

```nix
# modules/hosts/xen/default.nix
{ config, ... }:
{
  flake.modules.nixos.xen = {
    imports = [ ./hardware-configuration.nix ] ++ (with config.flake.modules.nixos; [
      asus base desktop docker games keyd nix-ld security
    ]);

    networking.hostName = "xen";
    nixpkgs.hostPlatform = "x86_64-linux";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    home-manager.users.sboynton = {
      imports = with config.flake.modules.homeManager; [
        asus cli desktop hyprland wayland keyd sboynton
      ];

      # Per-host overrides live in the host module too.
      wayland.windowManager.hyprland.settings.monitor = [ ",preferred,auto,1.5" ];
    };

    system.stateVersion = "25.11";
  };
}
```

`flake.nix` only has to hand the host module to `nixosSystem`:

```nix
flake.nixosConfigurations = {
  xen = nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos.xen ];
  };
  "Sam-Desktop" = nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos."Sam-Desktop" ];
  };
};
```

Adding a machine is one new directory under `modules/hosts/` plus one line in
`flake.nix`. Feature modules are swapped by editing a single host file.

## Build flow

```mermaid
flowchart TB
    U([just deploy]):::entry
    U --> R[nixos-rebuild switch<br/>--flake .#HOST]
    R --> F[[flake.nix<br/>nixosSystem { modules = [ HOST ] }]]:::flake

    F --> hostMod[hosts/HOST/default.nix<br/>━━━━━<br/>composition aggregator<br/>hostname · boot loader<br/>hardware-configuration<br/>per-host overrides<br/>stateVersion]:::host

    hostMod --> SYS[imports list<br/>system feature modules]:::group
    hostMod --> HM[home-manager.users.USER.imports<br/>home feature modules]:::group

    SYS --> bN[base system.nix<br/>kernel · locale · user · overlays<br/>home-manager nixos module]:::always
    SYS --> featN[base feature modules<br/>desktop · docker · asus · …]:::feature

    HM --> usr[users/sboynton<br/>identity]:::always
    HM --> cli[base cli.nix<br/>CLI tools]:::always
    HM --> featH[base HM modules<br/>desktop · hyprland · wayland · asus · …]:::feature

    featN -. imports .-> ih[inputs.hyprland]:::input
    featN -. imports .-> ia[inputs.asus-fan]:::input
    featN -. imports .-> iw[inputs.nixos-wsl]:::input

    classDef entry fill:#cfe,stroke:#393
    classDef flake fill:#fdc,stroke:#a60
    classDef host fill:#ffc,stroke:#aa0
    classDef group fill:#def,stroke:#36a
    classDef always fill:#efe,stroke:#393
    classDef feature fill:#fef,stroke:#a3a
    classDef input fill:#eee,stroke:#888,stroke-dasharray:4 2
```

**Reading it:**
- **Yellow host file** is the composition aggregator — it's where a new
  machine's module list, hostname, boot loader, hardware import, and per-host
  overrides all live. `flake.nix` just hands it to `nixosSystem`.
- **Green "always" modules** (`base system`, `cli`, user identity) appear in every host's imports.
- **Pink feature modules** are included per-host by editing the host file — WSL doesn't get
  hyprland, xen doesn't get nixos-wsl.
- **Dashed grey upstream imports** (hyprland, asus-fan, nixos-wsl) are pulled in
  by their feature modules, so unused inputs don't evaluate.

## Bootstrap (new machine)

The minimal path from a fresh NixOS install to this flake owning the system.
You do **not** need to change the hostname in `/etc/nixos/configuration.nix` —
`nh ... -H <hostname>` selects which `nixosConfigurations.<name>` entry to
build, and that entry's `networking.hostName` sets the running hostname on
activation.

1. Install NixOS (minimal or graphical ISO) and log in.
2. Get networking: `nmtui` for wireless, nothing to do for wired.
3. Enable flakes — the only edit you'll make to `/etc/nixos/`:
   ```nix
   # /etc/nixos/configuration.nix
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
   ```
   Then `sudo nixos-rebuild switch` once so the system nix understands flakes.
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
6. Write `modules/hosts/<hostname>/default.nix` and register the host in
   `flake.nix` (see [Adding a host](#adding-a-host) for templates).
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

2. Write `modules/hosts/<hostname>/default.nix` — the composition aggregator.
   Typical laptop running hyprland:
   ```nix
   { config, ... }:
   {
     flake.modules.nixos.<hostname> = {
       imports = [ ./hardware-configuration.nix ] ++ (with config.flake.modules.nixos; [
         base desktop keyd      # pick the system-level features this host needs
       ]);

       networking.hostName = "<hostname>";
       nixpkgs.hostPlatform = "x86_64-linux";

       boot.loader.systemd-boot.enable = true;
       boot.loader.efi.canTouchEfiVariables = true;

       home-manager.users.sboynton = {
         imports = with config.flake.modules.homeManager; [
           cli desktop hyprland wayland sboynton
         ];

         # Per-host overrides go here too, e.g. monitor layout:
         wayland.windowManager.hyprland.settings.monitor = [
           ",preferred,auto,1.5"
         ];
       };

       system.stateVersion = "25.11";
     };
   }
   ```

   For WSL, drop hardware import + boot loader (`nixos-wsl` handles both) and
   keep the home list lean:
   ```nix
   { config, ... }:
   {
     flake.modules.nixos.<hostname> = {
       imports = with config.flake.modules.nixos; [ base wsl ];

       networking.hostName = "<hostname>";
       nixpkgs.hostPlatform = "x86_64-linux";

       home-manager.users.sboynton.imports = with config.flake.modules.homeManager; [
         cli sboynton
       ];

       system.stateVersion = "25.11";
     };
   }
   ```

3. Register the host in `flake.nix` — one line per host:
   ```nix
   flake.nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
     modules = [ config.flake.modules.nixos.<hostname> ];
   };
   ```

4. Multi-monitor? Add more entries to the `settings.monitor` list in the host
   module. The compositor-wide `xwayland.force_zero_scaling = true` default
   already lives in `wayland/hyprland/core.nix`, so hosts only need the
   per-display lines:
   ```nix
   wayland.windowManager.hyprland.settings.monitor = [
     "eDP-1,1920x1200@60,0x0,1.5"
     "DP-1,3840x2160@60,1920x0,2.0"
   ];
   ```
   Omit entirely to let hyprland auto-detect.

5. Stage (flakes ignore untracked files), preview, build as `boot`, reboot:
   ```bash
   git add -A
   just diff                                        # shows the nvd closure diff
   nh os boot . -H <hostname>
   sudo reboot
   ```

   After the first clean boot, `just deploy` (or `nh os switch . -H <hostname>`) handles subsequent changes.

## Adding a feature module

1. Create `modules/base/<feature>.nix` (or `modules/base/<category>/<feature>.nix`).
2. Declare one or more module classes:
   ```nix
   { inputs, ... }:   # optional — only if the module uses flake inputs
   {
     flake.modules.nixos.<feature> = { pkgs, lib, ... }: {
       # system-level config
     };

     flake.modules.homeManager.<feature> = { pkgs, ... }: {
       # home-manager config
     };
   }
   ```
3. Add `<feature>` to the relevant host's `imports` (for nixos features) or
   `home-manager.users.<user>.imports` (for HM features) in
   `modules/hosts/<hostname>/default.nix`.

No `my.*.enable` toggles — if a module is in a host's imports list, it's on; if not, it's never evaluated.

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
3. If nothing in the Nix config references it, it's GPT auto-discovery on an orphan partition — `wipefs` it (see Bootstrap step 9).

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
