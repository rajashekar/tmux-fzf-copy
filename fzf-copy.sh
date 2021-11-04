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
        nohup echo "$@" | pbcopy
    elif hash xclip &>/dev/null; then
        nohup echo "$@" | xclip
    elif hash xsel &>/dev/null; then
        nohup echo "$@" | xclip
    fi
}

limit='screen'
[[ $# -ge 2 ]] && limit=$2

if [[ $limit == 'screen' ]]; then
    content="$(tmux capture-pane -J -p)"
else
    content="$(tmux capture-pane -J -p -S -"$limit")"
fi

mapfile -t urls < <(echo "$content" |grep -oE '(https?|ftp|file):/?//[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]')
mapfile -t wwws < <(echo "$content" |grep -oE '(http?s://)?www\.[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}(/\S+)*' | grep -vE '^https?://' |sed 's/^\(.*\)$/http:\/\/\1/')
mapfile -t ips  < <(echo "$content" |grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(:[0-9]{1,5})?(/\S+)*' |sed 's/^\(.*\)$/http:\/\/\1/')
mapfile -t gits < <(echo "$content" |grep -oE '(ssh://)?git@\S*' | sed 's/:/\//g' | sed 's/^\(ssh\/\/\/\)\{0,1\}git@\(.*\)$/https:\/\/\2/')
mapfile -t all < <(echo "$content" |grep -oE '\b[^ ]+\b')

if [[ $# -ge 1 && "$1" != '' ]]; then
    mapfile -t extras < <(echo "$content" |eval "$1")
fi

items=$(printf '%s\n' "${urls[@]}" "${wwws[@]}" "${ips[@]}" "${gits[@]}" "{all[@]}" "${extras[@]}" |
    grep -v '^$' |
    sort -u |
    nl -w3 -s '  '
)
[ -z "$items" ] && exit

mapfile -t chosen < <(fzf_filter <<< "$items" | awk '{print $2}')

for item in "${chosen[@]}"; do
    copy_text "$item" &>"/tmp/tmux-$(id -u)-fzf-copy.log"
done
