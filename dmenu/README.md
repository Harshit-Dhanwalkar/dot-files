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

- [x] Custom Fuzzy match
      I have implemented my version of fuzzy match (being very premitive, it requires you to type exactly the first letters in order)
      For e.g.: if you are searching for `Reddit`
  - Works for `red`,`rdd`,`redit`
  - Does NOT work for `rdt`, `r d t`
- [x] Cycle list/menu

Other patches:

- [x] https://tools.suckless.org/dmenu/patches/numbers/
- [x] https://tools.suckless.org/dmenu/patches/alpha/
- [x] https://tools.suckless.org/dmenu/patches/desktoponly/
- [x] https://tools.suckless.org/dmenu/patches/colored-caret/
- [x] https://tools.suckless.org/dmenu/patches/no-input/ -> for powermenu
- [x] https://tools.suckless.org/dmenu/patches/mouse-support/
  - [ ] https://tools.suckless.org/dmenu/patches/mouse-support/dmenu-mousesupport-motion-5.2.diff
  - [ ] https://tools.suckless.org/dmenu/patches/mouse-support/dmenu-mousesupport-motion-5.2.diff
  - [ ] https://tools.suckless.org/dmenu/patches/mouse-support/dmenu-mousesupportwithgrid-5.0.diff
- [x] https://tools.suckless.org/dmenu/patches/dmenupadding/
- [x] https://tools.suckless.org/dmenu/patches/vertfull/
- [ ] https://tools.suckless.org/dmenu/patches/fuzzyhighlight/
- [ ] https://tools.suckless.org/dmenu/patches/xyw/ -> setting window position and width
- [ ] https://tools.suckless.org/dmenu/patches/printindex/
- [ ] https://tools.suckless.org/dmenu/patches/png_images/
- [ ] https://tools.suckless.org/dmenu/patches/password/
- [ ] https://tools.suckless.org/dmenu/patches/case-insensitive/
- [ ] https://tools.suckless.org/dmenu/patches/preselect/
- [ ] https://tools.suckless.org/dmenu/patches/initialtext/
- [ ] https://tools.suckless.org/dmenu/patches/multi-selection/
- [ ] https://tools.suckless.org/dmenu/patches/grid/
  - [ ] https://tools.suckless.org/dmenu/patches/gridnav/
- [ ] https://tools.suckless.org/dmenu/patches/line-height/
- [ ] https://tools.suckless.org/dmenu/patches/dynamicoptions/
- [ ] https://tools.suckless.org/dmenu/patches/pipeout/
- [ ] https://tools.suckless.org/dmenu/patches/navhistory/
- [ ] https://tools.suckless.org/dmenu/patches/no-sort/
- [ ] https://tools.suckless.org/dmenu/patches/border/

Demnu clipboard manager: https://github.com/cdown/clipmenu

## TODO

- [ ] By adding Mouse support I also want to exit menu when click outside of menu.
- [ ] Add icon support like rofi.
