# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

- `nvim` – LazyVim config with Omarchy theme integration
- `fish` – fish shell config (requires fish)
- `herdr` – herdr config
- `opencode` – OpenCode config
- `root` – files that live directly in `$HOME` (`.gitconfig`, `.tmux.conf`)

## Install

```bash
./install.sh nvim          # stow nvim + wire up the Omarchy theme link
./install.sh root opencode # stow other packages
```

`install.sh` uses `stow --no-folding`, so each file is linked individually.
That keeps `~/.config/nvim/lua/plugins/theme.lua` a real path, which
`install.sh` then points at
`~/.local/state/omarchy/current/theme/neovim.lua` so Neovim follows Omarchy
theme switches. The link is untracked (see `.gitignore`) because its relative
target only resolves from `~/.config`.

Stowing `root` creates `~/.gitconfig` and `~/.tmux.conf`. If XDG variants
exist (`~/.config/git/config`, `~/.config/tmux/tmux.conf`), back them up and
remove them first: Git merges both global configs, and tmux only reads
`~/.tmux.conf` when it exists.

tmux requires the tmux plugin manager; it is not required when using herdr:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
