# TMUX Session Management

Simple, persistent session management for neovim and AI agents.

## Philosophy
- **Sessions only** - no splits/panes needed
- **Persistent** - sessions survive reboots (auto-save every 15 min)
- **Fast switching** - fuzzy finder for sessions
- **Minimal** - no status bar, just your terminal

## Essential Keybinds

### Inside tmux:
- `Ctrl-b s` - **Fuzzy session picker** (your main tool!)
- `Ctrl-b d` - **Detach** from session (leaves it running)
- `Ctrl-b $` - **Rename** current session
- `Ctrl-b r` - **Reload config**
- `Ctrl-b ?` - **Show all keybinds** (help)

### Auto-Save (Resurrect/Continuum):
- Auto-saves every 15 minutes
- Auto-restores on tmux startup
- `Ctrl-b Ctrl-s` - **Manual save** (force save now)
- `Ctrl-b Ctrl-r` - **Manual restore** (shouldn't need this)

## Terminal Commands

```bash
# Starting/Attaching
tmux                    # Attach to last session (or create new)
tmux new -s name        # Create new named session
tmux attach             # Attach to last session
tmux attach -t name     # Attach to specific session
tmux a                  # Short for attach
tmux a -t name          # Attach to specific session (short)

# Session Management
tmux ls                 # List all sessions
tmux kill-session -t name   # Kill specific session
tmux kill-server        # Kill ALL sessions (nuclear option)
```

## Workflow

1. **Create session:** `tmux new -s myproject`
2. **Work in session** (neovim, agent, etc.)
3. **Switch sessions:** `Ctrl-b s` → fuzzy find → select
4. **Detach:** `Ctrl-b d` (session keeps running)
5. **Re-attach later:** `tmux a -t myproject`
6. **Don't worry about losing work** - auto-saves every 15 min!

## Plugins

- **TPM** - Plugin manager
- **tmux-resurrect** - Save/restore sessions
- **tmux-continuum** - Auto-save resurrect every 15 min
- **tmux-sessionx** - Fuzzy session picker with fzf

### Installing/Updating Plugins

```bash
# Inside tmux:
Ctrl-b I          # Install new plugins (capital I)
Ctrl-b U          # Update all plugins (capital U)
Ctrl-b Alt-u      # Uninstall removed plugins
```

## Troubleshooting

### Status bar won't go away
```bash
tmux kill-server    # Kill all sessions
tmux                # Start fresh
```

### Config not reloading
```bash
./link.sh           # Re-link dotfiles first
tmux kill-server    # Then restart
tmux
```

### Plugins not working
```bash
# Inside tmux:
Ctrl-b I            # Reinstall plugins
```
