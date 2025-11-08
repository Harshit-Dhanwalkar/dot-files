# My Dot Files

This repository contains configuration files and installation notes for my preferred software setup, primarily targeting a Debian/Ubuntu-based Linux distribution.

---

## Package Managers

1.  <details>
    <summary>HomeBrew</summary>
    <p>Installation</p>

    ```bash
    /bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
    ```

    </details>

2.  <details>
    <summary>Flatpak</summary>
    <p>Installation</p>

    ```bash
    sudo apt install flatpak
    # Add the Flathub repository:
    flatpak remote-add --if-not-exists flathub [https://dl.flathub.org/repo/flathub.flatpakrepo](https://dl.flathub.org/repo/flathub.flatpakrepo)
    ```

    </details>

3.  <details>
    <summary>Cargo and Rust</summary>
    <p>Installation</p>

    ```bash
    curl [https://sh.rustup.rs](https://sh.rustup.rs) -sSf | sh # cargo
    curl --proto '=https' --tlsv1.2 -sSf [https://sh.rustup.rs](https://sh.rustup.rs) | sh # rustup
    ```

    </details>

---

## Terminal Emulators 🖥️

1.  <details>
    <summary>Kitty</summary>
    <p>

    - [kitty](https://sw.kovidgoyal.net/kitty/)

    </p>
    <p>Installation</p>

    ```bash
    curl -L [https://sw.kovidgoyal.net/kitty/installer.sh](https://sw.kovidgoyal.net/kitty/installer.sh) | sh /dev/stdin
    ```

    </details>

2.  <details>
    <summary>ST</summary>
    <p>

    - [suckless](https://st.suckless.org/)
    </p>
    <p>Installation</p>

    ```bash
    # Going to update soon
    ```

    </details>

---

## Applications ✨

1.  <details>
    <summary>Nvim</summary>
    <p>Installation</p>

    ```bash
    brew install neovim
    ```

    - image.nvim

    ```bash
    sudo apt install libmagicwand-dev #(for nvim image.lua)
    ```

    - LaTex (VimTex)

    ```bash
    sudo apt install latexmk
    sudo apt install texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-bibtex-extra
    sudo apt install texlive-luatex
    sudo apt install texlive-fonts-extra texlive-extra-utils
    sudo apt install texlive-pstricks
    sudo apt install texlive-metapost
    sudo apt install libsynctex-dev # For synctex support (forward/reverse search)

    # apt `zlib' version is `libz.so.1.2.1`so used brew`libz.so.1.3.1`
    sudo ln -sf /home/linuxbrew/.linuxbrew/opt/zlib/lib/libz.so.1.3.1 /usr/lib/libz.so.1.3.1
    sudo ln -sf /home/linuxbrew/.linuxbrew/opt/zlib/lib/libz.so.1 /usr/lib/libz.so.1
    sudo ldconfig

    pip3 install inkscape-figures
    ```

    </p>
    </details>

2.  <details>
    <summary>Inkscape</summary>
    <p>Installation</p>

    ```bash
    sudo add-apt-repository ppa:inkscape.dev/stable
    sudo apt update
    sudo apt install inkscape
    ```

    </details>

3.  <details>
    <summary>Qutebrowser</summary>

    - [Qutebrowser](https://qutebrowser.org/index.html)

    <p>Installation</p>

    ```bash
    sudo apt install qutebrowser
    ```

    </p>
    </details>

4.  <details>
    <summary>Obsidian</summary>
    <p>Installation</p>

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
    <summary>Fastfetch</summary>
    <p>

    - [Github](https://github.com/fastfetch-cli/fastfetch.git)
    </p>
    <p>Installation</p>

    ```bash
    sudo apt install fastfetch
    ```

    </details>

10. <details>
    <summary>Dunst</summary>
    <p>
    - [Archwiki](https://wiki.archlinux.org/title/Dunst)
    </p>
    <p> Installation</p>

    ```bash
    sudo apt install dunst
    ```

    </p>
    </details>
