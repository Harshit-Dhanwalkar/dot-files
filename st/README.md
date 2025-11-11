## Patches added

- [alpha & changealpha (transparency)](https://st.suckless.org/patches/alpha/)
- Xresources w/ reload signal (pywal takes priority)
- ligatures
- scrollback ringbuffer, with mouse
- anysize (ensures compatibility with various gaps setups in tiling WMs)
- [Clipboard-mamanger](https://st.suckless.org/patches/clipboard/) for sync to OS clipboard (i.e.`wl-clipboard`)

## Other stuff

- If you aren't using `~/.Xresources` or [pywal](https://github.com/dylanaraps/pywal), default color palette is [Nord](https://www.nordtheme.com/).
- Read or change keybinds, default font/size, etc. in **config.h** - I'll update the man page at some point. Bindings are what you'd expect, besides:
  - `crlt + shift + c` & `crlt+ shift + v` for copy-paste
  - `alt + a` & `alt + s` to increase and decrease alpha (transparency) respectively
  - `alt + shift + k` & `alt + shift + j` to increase and decrease font size, respectively

# Install/Build

## Dependencies

```bash
sudo apt-get update
sudo apt-get install libharfbuzz-dev
```
