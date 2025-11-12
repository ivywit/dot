# Dotdex v2.0

A functional-first dotfiles management system with git integration, conflict resolution, and comprehensive validation.

## Features

- ✅ **Repository structure mirrors home directory** - Clear, intuitive organization
- ✅ **Interactive conflict resolution** - Never lose changes during sync
- ✅ **Comprehensive validation** - Path checking, type validation, symlink detection
- ✅ **Dry-run mode** - Preview changes before applying them
- ✅ **Status and diff commands** - See what's changed before syncing
- ✅ **Atomic operations** - Config updates are safe from corruption
- ✅ **Modular architecture** - Clean separation of concerns following Unix philosophy

## Architecture

The system follows functional programming principles with a micro-modular design:

```
lib/
├── core/              # Pure functions (single responsibility, no side effects)
│   ├── paths.sh       # Path operations and validation
│   ├── config.sh      # Config file operations
│   ├── git.sh         # Git operations
│   └── files.sh       # File operations
├── workflows/         # Compositions (combine pure functions)
│   ├── track.sh       # File tracking workflow
│   ├── push.sh        # Push workflow
│   └── pull.sh        # Pull workflow with conflict resolution
└── commands/          # Orchestrations (coordinate workflows)
    └── commands.sh    # Command handlers
```

## Installation

1. Clone this repository
2. Run `./dotdex.sh init <repo-url>` to initialize

## Usage

### Initialize

```bash
./dotdex.sh init git@github.com:user/dotfiles.git
```

### Track Files

```bash
./dotdex.sh track ~/.zshrc
./dotdex.sh track ~/.emacs.d
./dotdex.sh track ~/.tmux.conf
```

### Check Status

```bash
./dotdex.sh status          # See what's changed
./dotdex.sh diff ~/.zshrc   # See specific file differences
./dotdex.sh list            # List all tracked files
./dotdex.sh verify          # Verify all tracked files exist
```

### Sync Changes

```bash
# Preview changes
./dotdex.sh push --dry-run
./dotdex.sh pull --dry-run

# Sync
./dotdex.sh push            # Push local changes to repo
./dotdex.sh pull            # Pull repo changes to local
./dotdex.sh sync            # Bidirectional sync
```

### Untrack Files

```bash
./dotdex.sh untrack ~/.zshrc
```

## Repository Structure

Your dotfiles are stored in the `dotfiles/` directory, which mirrors your home directory structure:

```
/Users/you/projects/dot/
├── dotdex.sh              # Main script
├── lib/                   # Logic
├── dotfiles/              # Your dotfiles
│   ├── .zshrc
│   ├── .emacs.d/
│   │   ├── init.el
│   │   └── custom/
│   ├── .tmux.conf
│   └── .gitconfig
├── setup.sh               # Development environment setup
└── README.md              # This file
```

## Configuration

Config file: `~/.dotdex.json`

Format:
```json
{
  "version": "2.0",
  "repository": {
    "url": "git@github.com:user/dotfiles.git",
    "branch": "main",
    "dotfiles_dir": "dotfiles"
  },
  "files": [
    {
      "path": "/Users/you/.zshrc",
      "repo_path": ".zshrc",
      "type": "file",
      "tracked_at": "2025-11-11T10:30:00Z",
      "last_synced": "2025-11-11T10:35:00Z"
    }
  ]
}
```

## Conflict Resolution

When pulling, if both local and repository versions have changed, you'll get interactive options:

1. Keep local version (overwrite repo with local)
2. Keep repository version (overwrite local with repo)
3. Show diff
4. Open both in $EDITOR
5. Skip this file
6. Abort pull

## Migration from v1

If you have an existing dotdex v1 setup, run:

```bash
./migrate.sh
```

This will:
- Read your old config
- Show you the new commands to track your files
- Optionally initialize the new system

## Safety Features

- ✅ Validates paths exist before tracking
- ✅ Checks paths are under home directory
- ✅ Detects and rejects symbolic links
- ✅ Creates backups before overwriting files during pull
- ✅ Atomic config updates (no race conditions)
- ✅ Interactive conflict resolution
- ✅ Dry-run mode for all sync operations

## Design Principles

1. **Micro-modular** - Small, composable, single-purpose functions
2. **Unix philosophy** - Do one thing well
3. **Functional-first** - Pure functions → compositions → orchestrations
4. **Explicit errors** - Trackable, typed error handling
5. **Separation of concerns** - Logic (lib/) vs data (dotfiles/)

## Development

The codebase follows these principles:

- Pure functions in `lib/core/` have no side effects
- Compositions in `lib/workflows/` combine pure functions
- Orchestrations in `lib/commands/` coordinate workflows and handle side effects
- All functions use prompt-driven documentation format

## Troubleshooting

### Push fails with "src refspec main does not match any"

Your repository uses a different default branch (probably `master`). Update your config:

```bash
jq '.repository.branch = "master"' ~/.dotdex.json > ~/.dotdex.json.tmp
mv ~/.dotdex.json.tmp ~/.dotdex.json
```

### File not found warnings

Run `./dotdex.sh verify` to check all tracked files exist and are valid.

### Config seems corrupted

Your old config was backed up to `~/.dotdex.json.v1.backup`. You can restore it or reinitialize.

## License

MIT

## Author

Ivy Witter
