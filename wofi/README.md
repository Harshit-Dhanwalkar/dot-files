# My `wofi` configuration

- Author  : Harshit Prashant Dhanwalkar
- Github  : @Harshit-Dhanwalkar

# Build from source

<p>

- [Gitlab](https://gitlab.com/dgirault/wofi.git)
</p>

<p>Installation</p>
<p>

```bash
sudo apt install mercurial libwayland-dev libgtk-3-dev pkgconf meson ninja-build libjson-glib-dev
git clone https://gitlab.com/dgirault/wofi.git wofi
cd wofi
mkdir .hg
meson setup build
ninja -C build
```

Put binaries in the `/usr/local/bin/`

```bash
sudo mv build/wofi /usr/local/bin/
```

Put binaries in the `/usr/local/bin/`

```bash
sudo mv build/dmenu /usr/local/bin/
```

</p>
