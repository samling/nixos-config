### Dotfiles

My ever-growing collection of dotfiles and configs.

### Prereqs
* `git`
* `just`
* `direnv`
* [doppler cli](https://aur.archlinux.org/packages/doppler-cli-bin)
* [chezmoi](https://github.com/twpayne/chezmoi)

### Doppler CLI tl;dr

`doppler login`
`doppler setup`

### Chezmoi tl;dr
```
chezmoi init <repo> {--source=path/to/chezmoi}  # Initialize chezmoi
chezmoi apply {-n}                              # Apply changes to ~ {Dry run}
chezmoi archive                                 # Create an archive of the dotfiles
chezmoi cd                                      # cd to chezmoi source path
chezmoi merge                                   # Merge changes made to local copy with chezmoi-managed file
chezmoi update                                  # Pull latest version from git and apply changes

chezmoi add ~/.my_file                          # Manage new file
chezmoi forget ~/.my_file                       # Stop managing a file
chezmoi managed                                 # View managed files
```

### Installation

1. `nix-shell -p vim git just doppler direnv`
1. `doppler login`
1. `doppler setup`
1. `doppler secrets substitute ./.envrc.tmpl > .envrc`
1. Enable direnv with `eval "$(direnv hook bash)"`
1. `direnv allow`
1. `chezmoi init --source $(pwd)`
1. `chezmoi apply`
1. See [NIX.md](./NIX.md) for new host onboarding

### Notes
- See [this page](https://www.cyberciti.biz/faq/linux-unix-macos-fix-error-cant-open-display-null-with-ssh-xclip-command-in-headless/) to configure X11 forwarding over ssh
