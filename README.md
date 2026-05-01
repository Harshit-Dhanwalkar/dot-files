<div align="center">
  <img width="100%" src="https://capsule-render.vercel.app/api?type=waving&section=header&color=0284C7&fontColor=F0F9FF&height=256&text=Dotfiles&desc=My%20personal%20Dotfiles&fontAlignY=40" />
  <br />
</div>

- Author  : Harshit Prashant Dhanwalkar
- Github  : @Harshit-Dhanwalkar

This repository contains configuration files and installation notes for my preferred software setup, primarily for a Debian/Ubuntu-based Linux distribution.

---

## Package Managers

1.  <details>
    <summary>PIP3</summary>
    <p>
    - [Website]()
       </p>
       <p>Installation</p>
       <p>

    ```bash
    sudo apt install python3-pip
    ```

    </p>
    </details>

2.  <details>
    <summary>HomeBrew</summary>
    <p>
    - [Website](https://brew.sh/)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

    Add `PATH`in `~/.bashrc`

    ```bash
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
    export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
    export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"
    export LD_LIBRARY_PATH="/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH"

    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ```

    </p>
    </details>

3.  <details>
    <summary>Flatpak</summary>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt install flatpak
    # Add the Flathub repository:
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    ```

  </p>
  </details>

4.  <details>
    <summary>Cargo and Rust</summary>
    <p>Installation</p>
    <p>

    ```bash
    curl https://sh.rustup.rs -sSf | sh # cargo
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # rustup
    ```

  </p>
  </details>

---

## Terminal Emulators

1.  <details>
    <summary>Kitty</summary>
    <p>
    - [kitty](https://sw.kovidgoyal.net/kitty/)
      </p>
      <p>Installation</p>
      <p>

    ```bash
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    ```

    </p>
    </details>

2.  <details>
    <summary>ST</summary>
    <p>
    - [ST (simple terminal)](https://st.suckless.org/)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    # Dependencies for suckless builts
    sudo apt install libxext-dev libxrandr-dev libxss-dev

    git clone https://git.suckless.org/st ~/.config/st/
    cd ~/.config/st/
    sudo make install
    ```

    <p>
    </details>

---

## Applications

1.  <details>
    <summary>Nvim</summary>
    <p>
    - [Nvim](https://neovim.io/)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    brew install neovim
    ```

    For more see [neovim](./nvim/README.md)
    </p>
    </details>

2.  <details>
    <summary>Inkscape</summary>
    <p>
    - [Inkscape](https://inkscape.org/)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo add-apt-repository ppa:inkscape.dev/stable
    sudo apt update
    sudo apt install inkscape
    ```

    </p>
    </details>

3.  <details>
    <summary>Qutebrowser</summary>
    <p>
    - [Qutebrowser](https://qutebrowser.org/index.html)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt install qutebrowser
    ```

    </p>
    </details>

4.  <details>
    <summary>Obsidian</summary>
    <p>
    - [Obsidian](https://obsidian.md/)
    </p>
    <p>Installation</p>
    <p>

    Via flatpak: [flathub](https://flathub.org/en/apps/md.obsidian.Obsidian)

    ```bash
    flatpak install flathub md.obsidian.Obsidian
    ```

    </p>
    </details>

5.  <details>
    <summary>QEMU</summary>
    <p>
    - [QEMU](https://www.qemu.org/)
      - Check Virtualization Extension by running following command to make sure you’ve enabled virtualization in on your system. It should be above 0
        - If the output is zero then go to bios settings and enable VT-x (Virtualization Technology Extension) for Intel processor and AMD-V for AMD processor.

    ```bash
    egrep -c '(vmx|svm)' /proc/cpuinfo
    ```

        </p>
        <p>Installation</p>
        <p>

    ```bash
    sudo apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
    ```

    - Verify that Libvirtd service is started

    ```bash
    sudo systemctl status libvirtd.service
    ```

    - Start Default Network for Networking
      - VIRSH is a command to directly interact with our VMs from terminal. We use it to list networks, vm-status and various other tools when we need to make tweaks. Here is how we start the default and make it auto-start after reboot.

    ```bash
    sudo virsh net-start default
    ```

    - Network default started

    ```bash
    sudo virsh net-autostart default
    ```

    - Network default marked as autostarted
      - Check status with:
      ```bash
      sudo virsh net-list --all
      ```
    - Name State Autostart Persistent
      `default active yes yes`
    - Add User to libvirt to Allow Access to VMs

    ```bash
    sudo usermod -aG libvirt $USER
    sudo usermod -aG libvirt-qemu $USER
    sudo usermod -aG kvm $USER
    sudo usermod -aG input $USER
    sudo usermod -aG disk $USER
    ```

    - Reboot and you are Finished!

    ```bash
    virt-manager
    ```

    </p>
    </details>

6.  <details>
    <summary>OBS studio</summary>
    <p>
    - [OBS Project](https://obsproject.com/)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt install obs-studio
    ```

    </p>
    </details>

7.  <details>
    <summary>Blender</summary>
    <p>
    - Downloads via: [Blender.org](https://www.blender.org/download/)
    </p>
    </details>

8.  <details>
    <summary>Aseprite</summary>
    <p>
    - [Aseprite.org](https://www.aseprite.org/)
        </p>
        <p>Installation</p>
        <p>
    - Downloads via :
      - [Github](https://github.com/aseprite/aseprite.git)
        or
      - [Sourceforge](https://sourceforge.net/projects/aseprite.mirror/)

    ```bash
    unzip Downloads
    cd Asperite
    ./build.sh
    cd build/bin/
    ./asperite # for test
    ```

    ```bash
    mkdir -p ~/.local/share/aseprite
    cp ~/Downloads/Aseprite/build/bin/aseprite ~/.local/bin/
    cp -r ~/Downloads/Aseprite/build/bin/data ~/.local/share/aseprite/
    ```

    Also for thumbnailer script, create in `~/.local/bin/aseprite-thumbnailer.sh` :

    ```sh
    #!/usr/bin/sh
    # Aseprite Desktop Integration Module
    # Copyright (C) 2016  Gabriel Rauter

    # Licensed under the the MIT License ([https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)).

    if [ $# -ge 2 -a $# -lt 4 ]; then
    mkdir -p /tmp/Aseprite
    filename=${1//\//.}$RANDOM
    if [ $# -eq 2 ]; then
    aseprite -b --frame-range "0,0" $1 --sheet /tmp/Aseprite/$filename.png
    elif [ $# -eq 3 ]; then
    aseprite -b --frame-range "0,0" $1 --shrink-to "$3,$3" --sheet /tmp/Aseprite/$filename.png
    fi
    mkdir -p $(dirname "$2"); mv /tmp/Aseprite/$filename.png $2;
    else
    echo "Parameters for aseprite thumbnailer are: inputfile outputfile [size]"
    fi

    ```

    Make the script executable by :

    ```bash
    chmod +x ~/.local/bin/aseprite-thumbnailer.sh
    ```

    </p>
    </details>

9.  <details>
    <summary>Bluetooth</summary>
    <p>
    - [Website]()
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt-get install bluez-tools
    sudo apt install bluez blueman
    sudo apt install pavucontrol
    sudo apt install pipewire-audio-client-libraries pipewire-pulse
    sudo apt-get install --reinstall libreadline8 libreadline-dev
    sudo apt install linux-firmware
    # test
    blueman-manager
    bluetoothctl
    ```

    </p>
    </details>

10. <details>
    <summary>BTop++</summary>
    <p>
    - [Github](https://github.com/aristocratos/btop)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt install btop
    ```

    </p>
    </details>

11. <details>
    <summary>Dunst</summary>
    <p>
    - [Archwiki](https://wiki.archlinux.org/title/Dunst)
    - [Dunst website](https://dunst-project.org/)
    - [Github](https://github.com/dunst-project/dunst)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt install dunst
    # Dependencies
    sudo apt install libnotify-bin
    sudo apt install ncal # Calender
    ```

    </p>
    </details>

12. <details>
    <summary>Dmenu</summary>
    <p>
    - [suckless.org](http://tools.suckless.org/dmenu/)
    - [Git](https://git.suckless.org/dmenu)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    # Dependencies
    sudo apt install libxinerama-dev libx11-dev libxft-dev libfreetype6-dev

    git clone https://git.suckless.org/dmenu demnu
    mkdir ../src && mv * ../src && mv ../src . cd src
    mkdir ../build
    sudo make clean install
    ```

    </p>
    </details>

13. <details>
    <summary>Wofi</summary>
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
    </details>

14. <details>
    <summary>Yazi</summary>
    <p>
    - [Github](https://github.com/sxyazi/yazi)
    - [Website](https://yazi-rs.github.io/)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    brew update
    brew install yazi
    ```

    For plugins:

    ```bash
      sudo apt install mediainfo
    ```

   </p>
   </details>

15. <details>
    <summary>VLC player</summary>
    <p>
    - [Website]()
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt install vlc
    ```

   </p>
   </details>

16. <details>
    <summary>FFMPEG</summary>
    <p>
    - [Website]()
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt install ffmpeg
    ```

   </p>
   </details>

17. <details>
    <summary>Sioyek</summary>
    <p>
    - [Github](https://github.com/ahrm/sioyek)
    - [Website](https://sioyek.info/)
    </p>
    <p>Installation</p>
    <p>
    via flatpak: [flathub](https://flathub.org/en/apps/org.kde.kdenlive)

    ```bash
    flatpak install sioyek
    flatpak run com.github.ahrm.sioyek
    # if it fails to lanch
    QT_QPA_PLATFORM=wayland flatpak run com.github.ahrm.sioyek
    ```

   </p>
   </details>

18. <details>
    <summary>Sioyek</summary>
    <p>
    - [Github](https://github.com/sxyazi/yazi)
    - [Website](https://kdenlive.org/)
    </p>
    <p>Installation</p>
    <p>
    via flatpak: [flathub](https://flathub.org/en/apps/org.kde.kdenlive)

    ```bash
    flathub install kdenlive
    ```

   </p>
   </details>

19. <details>
    <summary>Telegram</summary>
    <p>
    - [flathub](https://flathub.org/en/apps/org.telegram.desktop)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    # flatpak install telegram
    flatpak install flathub org.telegram.desktop
    ```

   </p>
   </details>

20. <details>
    <summary>Fastfetch</summary>
    <p>
    - [Github](https://github.com/fastfetch-cli/fastfetch.git)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    sudo apt install fastfetch
    ```

    </p>
    </details>

---

## Tools

### Via apt

```bash
sudo apt install wl-clipboard
sudo apt install ripgrep 7zip
sudo apt install sxiv
sudo apt install slurp grim
sudo apt install okular zathura zathura-pdf-poppler zathura-djvu zathura-ps
sudo apt install tree
```

### Via homebrew:

```bash
brew install zoxide fzf imagemagick resvg
brew install tree-sitter
brew install cmake
brew install gcc@13
```

### Via Pip

```bash
# inkscape2tikz extension
pip install appdirs svg2tikz
```

### Latex

```bash
sudo apt install latexmk
sudo apt install biber texlive-publishers
sudo apt install texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-bibtex-extra
sudo apt install texlive-luatex
sudo apt-get install texlive-fonts-extra # noto.sty
sudo apt-get install texlive-science  # physics.sty
sudo apt install asymptote
sudo apt-get install texlive-full
```

---

## Appperance

1.  <details>
    <summary>Nerd Fonts</summary>
    <p>
    - [Github releases](https://github.com/ryanoasis/nerd-fonts/releases/)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
    unzip .JetBrainsMonozip -d ~/fonts/JetBrainsMono/
    # tar -xvf nerd-fonts-<version>-complete.tar.xz -C ~/nerd-fonts

    # Global Install
    sudo cp -r ~/nerd-fonts/JetBrainsMono/ /usr/share/fonts/
    fc-cache -fv
    fc-list | grep "JetBrains Mono"
    ```

2.  <details>
    <summary>Icon pack</summary>
    <p>
    - [Arashi](https://github.com/0hStormy/Arashi)
    </p>
    <p>Installation</p>
    <p>

    ```bash
    mkdir -p ~/.icons
    git clone https://github.com/0hStormy/Arashi

    # (For updating with newer version)
    cd ~/.icons/Arashi
    git fetch
    ```

    </p>
    </details>
