# How GNU Stow Works (Single-Package Setup)

The key insight: **Stow creates symlinks by mirroring directory structure.**

Your dotfiles repo is laid out *exactly* like your home directory:

```
~/dotfiles/                          ~/
├── .config/                         ├── .config → symlink
│   ├── fish/                        │   (stow "folds" the whole tree
│   ├── nvim/                        │    or individual files)
│   └── hypr/                        │
├── .ssh/                            ├── .ssh → ~/dotfiles/.ssh
├── .gitconfig                       ├── .gitconfig → ~/dotfiles/.gitconfig
└── ...                              └── ...
```

**The magic command:**
```bash
stow -t ~ .
```

This says: "Take the current directory (`.`) and symlink its contents into home (`~`)."

**That's it.** No packages, no complicated setup. The directory structure *is* the config.

## Tree Folding

Stow is smart. If `~/.config/fish/` doesn't exist, it symlinks the whole directory:
```
~/.config/fish → ~/dotfiles/.config/fish
```

If `~/.config/` already has other stuff, it symlinks individual files instead.

## Visual

```
┌─────────────────────────────────────────────────────────┐
│  ~/dotfiles/.config/nvim/init.lua                       │
│         │                                               │
│         │  stow -t ~ .                                  │
│         ▼                                               │
│  ~/.config/nvim/init.lua  →  (symlink to the above)     │
└─────────────────────────────────────────────────────────┘
```

## Why Single-Package?

Many stow tutorials use multiple "packages" (`stow fish`, `stow nvim`, etc). The single-package approach (`stow .`) is simpler:
- One command links everything
- Directory structure matches your actual home
- No mental overhead of "which package has what"
