#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# $1: option
# $2: default value
tmux_get() {
    local value
    value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

key="$(tmux_get '@fzf-copy-bind' 'u')"
history_limit="$(tmux_get '@fzf-copy-history-limit' 'screen')"
extra_filter="$(tmux_get '@fzf-copy-extra-filter' '')"
echo "$extra_filter" > /tmp/tmux-copy-filter

tmux bind-key "$key" run -b "$SCRIPT_DIR/fzf-copy.sh '$extra_filter' $history_limit";
