# tmux-fzf-copy

A tmux plugin to copy text using fuzzy search. 
I was looking for tmux plugin where I can quickly grab any text from above and paste it in current prompt. 
There are already amazing plugins like [tmux-copy-toolkit](https://github.com/CrispyConductor/tmux-copy-toolkit), 
but requires jumping to that location and selecting text and copy to current line.

This plulgin gives fzf fuzzy search for all the words in current buffer. This plugin is extended from [tmux-fzf-url](https://github.com/wfxr/tmux-fzf-url). 
Thanks to [Wenxuan](https://github.com/wfxr).

Here is a demo, where this plugin can be helpful, for example if you want to grab pod name 
(which often changes, so auto completions might not help) and ssh to it. Hope this helps.
![fzf-copy-demo](tmux-fzf-copy.gif "tmux fzf copy demo")

### 📥 Installation

Prerequisites:
* [`fzf`](https://github.com/junegunn/fzf)
* [`bash`](https://www.gnu.org/software/bash/) >= `4.0` (macOS ships with `bash` `3.2`!)

**Install using [TPM](https://github.com/tmux-plugins/tpm)**

Add this line to your tmux config file, then hit `prefix + I`:

``` tmux
set -g @plugin 'rajashekar/tmux-fzf-copy'
```

**Install manually**

Clone this repo somewhere and source `fzf-copy.tmux` at the config file.

### 📝 Usage

The default key-binding is `v`(of course prefix hit is needed), it can be modified by
setting value to `@fzf-copy-bind` at the tmux config like this:

``` tmux
set -g @fzf-copy-bind 'x'
```

Currently below are the capture groups used to grab words, lines and quotes.
```
mapfile -t words < <(echo "$content" |grep -oE '\b[^ ]+\b')
mapfile -t lines < <(echo "$content" |grep -oE '.*')
mapfile -t quotes < <(echo "$content" |grep -oE '".*"')
```

You can also extend the capture groups by defining `@fzf-copy-extra-filter`:

``` tmux
# simple example for capturing files like 'abc.txt'
set -g @fzf-copy-extra-filter 'grep -oE "\b[a-zA-Z]+\.txt\b"'
```

The plugin default captures the current screen. You can set `history_limit` to capture
the scrollback history:

```tmux
set -g @fzf-copy-history-limit '2000'
```

You can use custom fzf options by defining `@fzf-copy-fzf-options`.

```
# open tmux-fzf-copy in a tmux v3.2+ popup
set -g @fzf-copy-fzf-options '-w 50% -h 50% --multi -0 --no-preview --no-border'
```
