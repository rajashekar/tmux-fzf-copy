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

The default key-binding is `u`(of course prefix hit is needed), it can be modified by
setting value to `@fzf-copy-bind` at the tmux config like this:

``` tmux
set -g @fzf-copy-bind 'x'
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
