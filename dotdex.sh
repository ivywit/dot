#!/usr/bin/env bash
# dotdex - Dotfiles management tool v2.0
#
# A modular, functional-first dotfiles manager with git integration,
# conflict resolution, and comprehensive validation.

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source command handlers
source "$SCRIPT_DIR/lib/commands/commands.sh"

# Main entry point
main() {
    local command="${1:-}"

    # Shift args if command was provided
    if [[ -n "$command" ]]; then
        shift
    fi

    # Route to appropriate command
    case "$command" in
        init)
            cmd_init "$@"
            ;;
        track)
            cmd_track "$@"
            ;;
        untrack)
            cmd_untrack "$@"
            ;;
        list)
            cmd_list "$@"
            ;;
        verify)
            cmd_verify "$@"
            ;;
        status)
            cmd_status "$@"
            ;;
        diff)
            cmd_diff "$@"
            ;;
        push)
            cmd_push "$@"
            ;;
        pull)
            cmd_pull "$@"
            ;;
        sync)
            cmd_sync "$@"
            ;;
        help|--help|-h|"")
            cmd_help "$@"
            ;;
        *)
            echo "Error: Unknown command: $command" >&2
            echo "Run 'dotdex help' for usage" >&2
            exit 1
            ;;
    esac
}

# Handle errors
trap 'echo "Error: Command failed at line $LINENO" >&2' ERR

# Run main
main "$@"
