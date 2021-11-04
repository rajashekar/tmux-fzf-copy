#!/usr/bin/env bash

get_fzf_options() {
    local fzf_options
    local fzf_default_options='-d 35% -m -0 --no-preview --no-border'
    fzf_options="$(tmux show -gqv '@fzf-copy-fzf-options')"
    [ -n "$fzf_options" ] && echo "$fzf_options" || echo "$fzf_default_options"
}

fzf_filter() {
  eval "fzf-tmux $(get_fzf_options)"
}

copy_text() {
    if hash pbcopy &>/dev/null; then
        nohup echo -n "$@" | tmux load-buffer - && tmux save-buffer - | pbcopy | tmux paste-buffer
    elif hash xclip &>/dev/null; then
        nohup echo -n "$@" | tmux load-buffer - && tmux save-buffer - | xclip | tmux paste-buffer
    elif hash xsel &>/dev/null; then
        nohup echo -n "$@" | tmux load-buffer - && tmux save-buffer - | xsel | tmux paste-buffer
    fi
}

limit='screen'
[[ $# -ge 2 ]] && limit=$2

if [[ $limit == 'screen' ]]; then
    content="$(tmux capture-pane -J -p)"
else
    content="$(tmux capture-pane -J -p -S -"$limit")"
fi

mapfile -t words < <(echo "$content" |grep -oE '\b[^ ]+\b')
mapfile -t lines < <(echo "$content" |grep -oE '.*')
mapfile -t quotes < <(echo "$content" |grep -oE '".*"')

if [[ $# -ge 1 && "$1" != '' ]]; then
    mapfile -t extras < <(echo "$content" |eval "$1")
fi

items=$(printf '%s\n' "${words[@]}" "${lines[@]}" "${quotes[@]}" "${extras[@]}" |
    grep -v '^$' |
    sort -u |
    nl -w3 -s '  '
)
[ -z "$items" ] && exit

mapfile -t chosen < <(fzf_filter <<< "$items" | awk '{print $2}')

for item in "${chosen[@]}"; do
    copy_text "$item" &>"/tmp/tmux-$(id -u)-fzf-copy.log"
done
