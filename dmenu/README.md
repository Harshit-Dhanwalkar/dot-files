# My d`menu` configuration

- Author  : Harshit Prahant Dhanwalkar
- Github  : @Harshit-Dhanwalkar

Build from source

```bash
sudo make clean install
```

### Theme

To change them make changes in [config.h](./config.h)

### Patches

1. Fuzzy match

I have implemented my version of fuzzy match (being very premitive, it requires you to type exactly the first letters in order)
For e.g.: if you are searching for `Reddit`

- Works for `red`,`rdd`,`redit`
- ✖ Does NOT work for `rdt`, `r d t`

Useful patches:

- [x] Custom fuzzy match
- [x] https://tools.suckless.org/dmenu/patches/numbers/
- [x] https://tools.suckless.org/dmenu/patches/alpha/
- [ ] https://tools.suckless.org/dmenu/patches/desktoponly/
- [ ] https://tools.suckless.org/dmenu/patches/preselect/
- [ ] https://tools.suckless.org/dmenu/patches/case-insensitive/
- [ ] https://tools.suckless.org/dmenu/patches/mouse-support/
- [ ] https://tools.suckless.org/dmenu/patches/grid/
- [ ] https://tools.suckless.org/dmenu/patches/line-height/
- [ ] https://tools.suckless.org/dmenu/patches/png_images/
- [ ] https://tools.suckless.org/dmenu/patches/password/
- [ ] https://tools.suckless.org/dmenu/patches/no-input/ -> for powermenu

Demnu clipboard manager: https://github.com/cdown/clipmenu
