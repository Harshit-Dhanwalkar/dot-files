# My `Neovim` configuration

- Author  : Harshit Prashant Dhanwalkar
- Github  : @Harshit-Dhanwalkar

<img src="../assets/NeoVim.png" alt="Neovim" width="450">

---

## Custom utilities (in `lua/utilities/`)

1. [`datejumps`](./lua/Custom-plugins/datejumps.lua)

- Jumps to and fro in dates in markdown files.
  - key map `]d` for fro(next) and `[d` for back(previous).

2. [`openpdf`](./lua/utilities/openpdf.lua)

- Extracts the pdf file path from a Markdown or Wikilink on the current line and opens it in Zathura pdf viewer.
  - key map `<leader>oz`.

---

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
   # Python
   npm install -g pyright
   # Bash
   npm install -g bash-language-server
   # TypeScript/JavaScript
   npm install -g typescript typescript-language-server
   # Web Development
   npm install -g vscode-langservers-extracted
   npm install -g @tailwindcss/language-server
   npm install -g typescript typescript-language-server
   npm install -g vscode-langservers-extracted
   # Docker
   npm install -g dockerfile-language-server-nodejs
   # LaTeX (VimTeX)
   # :MasonInstall texlab
   # LanguageTool integration for LaTeX
   # :MasonInstall ltex-ls
   ```

   `:Mason` to get more LSP server

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

   # For integration with VimTex
   pip3 install inkscape-figures
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

4. Vimtex (LaTex)

   ```bash
   sudo apt install latexmk
   sudo apt install texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-bibtex-extra
   sudo apt install texlive-fonts-extra texlive-extra-utils
   sudo apt install texlive-luatex
   sudo apt install texlive-pstricks
   sudo apt install texlive-metapost
   sudo apt install libsynctex-dev # For synctex support (forward/reverse search)

   # apt `zlib' version is `libz.so.1.2.1` used over brew `libz.so.1.3.1`
   sudo ln -sf /home/linuxbrew/.linuxbrew/opt/zlib/lib/libz.so.1.3.1 /usr/lib/libz.so.1.3.1
   sudo ln -sf /home/linuxbrew/.linuxbrew/opt/zlib/lib/libz.so.1 /usr/lib/libz.so.1
   sudo ldconfig
   ```

   - Inkscape setup:

   ```bash
   pip3 install inkscape-figures
   ```

### Others

1. Wl-clipboard

   ```bash
   sudo apt install wl-clipboard
   ```
