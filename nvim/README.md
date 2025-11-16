# My `Neovim` configuration

- Author  : Harshit Prashant Dhanwalkar
- Github  : @Harshit-Dhanwalkar

<img src="../assets/NeoVim.png" alt="Neovim" width="450">

# Installation

   ```bash
   brew install neovim
   ```

## Dependencies

### Core Dependencies

1. Node.js for LSP and tree-sitter

   ```bash
   # Using nvm (recommended)
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   nvm install --lts
   ```

1. Treesitter

   ```bash
   npm install -g treesitter-cli
   which treesitter
   treesitter --version
   ```
   or
   ```bash
   brew install tree-sitter
   which treesitter
   treesitter --version
   ```

### LSP & Language Support

1. Language Support

   ```bash
   # Mason should handle most of these, but good to have:
   npm install -g typescript typescript-language-server
   npm install -g vscode-langservers-extracted
   npm install -g @tailwindcss/language-server
   npm install -g bash-language-server
   npm install -g pyright
   npm install -g dockerfile-language-server-nodejs
   ```

2. Rustup and Cargo for rust development (`rustaceanvim`, `rust-tools`)

   ```bash
   # Rustup
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   # Cargo
   curl https://sh.rustup.rs -sSf | sh
   ```

### Git & Version Control

1. Git (gitsigns, diffview, neogit)

   ```bash
   sudo apt install git
   ```

### Image & Media

1. Imagemagick for [image.nvim](https://github.com/3rd/image.nvim)

    ```bash
    sudo apt install imagemagick libmagickwand-dev
    ```

    - [Imagemagick Website](https://imagemagick.org/)
    - [Imagemagick Github](https://github.com/ImageMagick/ImageMagick.git)

2. Inkscape (Vector graphics)

   ```bash
   sudo apt install inkscape
   ```

   - [Inkscape Website](https://inkscape.org/)
   - [Inkscape Gitlab](https://gitlab.com/inkscape/inkscape)

### File Management

1. Ripgrep for Telescope file search

   ```bash
   sudo apt install ripgrep
   ```

2. fd-find (Telescope file finder)

   ```bash
   sudo apt install fd-find
   ```

3. fzf (Fuzzy finder)

   ```bash
   sudo apt install fzf
   ```

### Others

1. Wl-clipboard

   ```bash
   sudo apt install wl-clipboard
   ```
