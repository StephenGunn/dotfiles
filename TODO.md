# TODO — titan setup

## Needs your password (blocking)

- [ ] `sudo pacman -S quickshell papirus-icon-theme`
      `quickshell` is in `extra/` and is the only thing between you and the
      bar — `exec-once = quickshell` is already in `autostart.conf:18` and
      `Colors.qml` is generated, so a Hyprland restart brings it up.
      `papirus-icon-theme` is what `dunst` wants for notification icons.
- [ ] `~/dotfiles/scripts/set_default_shell.sh` — runs `chsh -s /usr/bin/fish`.
      Fish is installed and in `/etc/shells`; passwd still says bash.
- [ ] Restart Hyprland, confirm the bar appears.

## Push

- [ ] `gh auth login` — `gh auth status` reports no GitHub hosts. Both remotes
      are HTTPS. `~/.ssh/id_ed25519` now exists, so switching the remotes to
      SSH and adding the pubkey to GitHub also works.
- [ ] Push `theme-switcher` **first** — its dunst fix writes the drop-in that
      the dotfiles `dunstrc` expects. Pulling dotfiles first on another
      machine gives you an unthemed (but working) dunst until it catches up.
- [ ] Push `dotfiles`.

## On every other machine, after pulling

- [ ] Nothing to stash this time. The four generated files
      (`starship.toml`, `gtk-3.0/settings.ini`, `yazi/theme.toml`,
      `fish/fish_variables`) are untracked as of this round, so the pull
      removes them from the index but leaves your copies on disk.
- [ ] Re-run `theme-switch <theme>` to regenerate them plus the new
      `dunstrc.d/99-colors.conf`.
- [ ] Check `fish_user_paths` survived — titan's copy had dropped opam,
      flatpak, bun, pnpm, fly, rustup and jvm/default. It is untracked now, but
      any machine that already pulled a bad copy needs a look.
- [ ] `./link.sh` should run clean twice in a row. That is the regression test
      for the stow fix.

## Known-broken, not yet fixed

- [ ] **`.stow-local-ignore` is mostly inert.** Stow matches patterns
      containing `/` as `(^|/)(pattern)(/|$)` against `"/<path>"`
      (`Stow.pm:1500`), so a leading `^` can never match. Dead patterns:
      `^scripts/`, `^docs/`, `^grub/`, `^packages/`, `^wallpapers/`,
      `^.config/xfce4/...`. That is why `~/scripts`, `~/docs`, `~/packages`,
      `~/wallpapers` and `~/grub` are symlinked into `$HOME` despite being
      listed. Fix = drop the `^`; the consequence is those five symlinks
      disappear on next restow.
- [ ] **Two dead autostart lines** left in `autostart.conf` after `1fcc874`
      removed the `agsv1` one: `exec = eww daemon` (line 30) and
      `exec-once = /usr/local/bin/pypr` (line 42, path does not exist).
      `eww` is an ags-era leftover now that the bar is quickshell; pyprland
      you may actually want back for scratchpads, and `keybinds.conf:143-144`
      still binds Super+X and Super+Z to `pypr zoom`.
- [ ] **`config.fish` appends to `fish_user_paths` on every shell start**
      (lines 37, 79, 93: `set -U fish_user_paths ... $fish_user_paths`).
      Universal var, so it grows without bound — titan's copy already had
      `.turso` twice. Guard with `contains ... || set -U ...`, or use
      `fish_add_path`.
- [ ] **`waypaper/config.ini` still uses `swww_*` backend keys** while the
      binary is now `awww`. Untested — waypaper may or may not care.
- [ ] **`.local/bin/theme-switch` is tracked as a symlink** to an absolute
      `/home/stephen/projects/theme-switcher/...` path. `link.sh` recreates it
      on every run anyway, so tracking it only means the repo goes dirty on any
      machine where that clone lives elsewhere.

## Done this session

- **The previous "untrack generated files" commit never actually untracked
  them.** `51be4c6` describes a `git rm --cached` of four files but the diff
  shows it committing their contents instead; all four were still tracked.
  Pushing it as-is would have done the exact thing the commit was written to
  prevent — shove titan's truncated `PATH` onto every other machine. Done for
  real now.
- **Bar:** `quickshell` was listed only in `packages/jovian.md` while
  `autostart.conf` runs it on every host. Moved to `core.md`.
- **Notifications:** `.config/dunst/dunstrc` was deleted from the repo back in
  `d6056b8`, so dunst had been falling back to `/etc/dunst/dunstrc` system
  defaults — that is the "unskinned after updates" symptom, since pacman owns
  that file. Restored from git history, with `monitor = DP-3` dropped (that
  output does not exist on this laptop) and the post-1.12 `height`/`offset`
  tuple syntax.
- **Notification theming:** `theme-switch`'s dunst step edited
  `~/dotfiles/.config/dunst/dunstrc` in place — a file that had not existed
  since `d6056b8` — so it silently hit its skip branch every run. It now
  renders the previously unused `templates/dunstrc` to the gitignored
  `.config/dunst/dunstrc.d/99-colors.conf` drop-in, which dunst loads after
  the base config. The template's `{color.strip}` filters were also dropping
  the leading `#`, which dunst rejects as an invalid color.
- Gitignored machine state: `systemd/user/*.wants/`, the
  `pipewire-session-manager.service` alias symlink, `.ssh/known_hosts`,
  `claude-code-url-handler.desktop`, and `.local/bin/*` behind an allowlist
  so pipx/npm shims stop showing up.
- Dropped the stale `.config/alacritty/themes` line from `.gitignore` — the
  directory is tracked, so the ignore had no effect and only caused confusion.

## Done previously

- Fixed `link.sh` — it succeeded on a fresh machine and failed on every run
  after, because Step 4's hypridle symlink collided with stow's own on the
  next pass. Also fixed the conflict reporter that printed the word "is"
  instead of a filename.
- Fixed `theme-switch` dying at `apply_tmux` under `set -e` before
  `apply_quickshell` ever ran — the real reason `Colors.qml` never existed.
- Stopped `theme-switch` editing tracked configs (tmux, ghostty).
- `swww` → `awww` in `random-wallpaper`; wallpapers work again.
- Ghostty font-size moved to gitignored `~/.config/ghostty/local.conf` (17 on
  titan) so it does not follow you to other machines.
