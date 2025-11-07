# My dot files

## Package managers

1. <details>
     <summary>HomeBrew</summary>
     <p>Installation

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

   ```

     </p>
   </details>

2. <details>
     <summary>Flatpak</summary>
     <p>Installation

   ```bash
   sudo apt install flatpak
   #Add the Flathub repository:
   flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
   ```

     </p>
   </details>

3. <details>
     <summary>Cargo and Rust</summary>
     <p>Installation

   ```bash
   curl https://sh.rustup.rs -sSf | sh # cargo
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # rustup
   ```

     </p>
   </details>

## Terminal Emulators

1. <details>
     <summary>Kitty</summary>
     <p>Installation

   ```bash
   curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
   ```

     </p>
   </details>

2. <details>
      <summary>ST</summary>
      <p>Installation

   ```bash
   # Going to update soon
   ```

     </p>
   </details>

## Applications

1. <details>
     <summary>Nvim</summary>
     <p>

   ```bash
   brew install neovim
   ```

     </p>
   </details>

2. <details>
     <summary>Inkscape</summary>
     <p>

   ```bash
   sudo add-apt-repository ppa:inkscape.dev/stable
   sudo apt update
   sudo apt install inkscape
   ```

     </p>
   </details>

3. <details>
   <summary>Qutebrowser</summary>
     <p>

   ```bash
   sudo apt install qutebrowser
   ```

     </p>
   </details>

4. <details>
   <summary>Obsidian</summary>
     <p>

   ```bash
      flatpak install flathub md.obsidian.Obsidian
   ```

     </p>
   </details>

5. Blender
6. <details>
   <summary>QEMU</summary>
     <p>

   ```bash
   sudo apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
   ```

   Verify that Libvirtd service is started

   ```bash
   sudo systemctl status libvirtd.service
   ```

     </p>
   </details>

7. Asperite
8. <details>
   <summary>OBS studio</summary>
     <p>

   ```bash
   sudo apt install obs-studio
   ```

     </p>
   </details>
