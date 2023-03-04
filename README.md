<h1 align="center">nvim-config</h1>
<p align="center">
  <b>Just another opinionated, visually appealing Neovim IDE.</b>
  <br />
  <b>Configured for Windows, supports LaTeX, Python, Lua, C#, HTML, CSS, and Javascript.</b>
  <br />
  <br />
  <a href="https://github.com/neovim/neovim">
    <img
      src="https://img.shields.io/badge/requires-neovim%200.8%2B-green?color=76946A&labelColor=16161D&style=for-the-badge&logo=neovim"
    />
  </a>
  <a href="https://github.com/Neelfrost/dotfiles/blob/main/LICENSE"
    ><img
      alt="license"
      src="https://img.shields.io/github/license/Neelfrost/dotfiles?labelColor=151515&color=A270BA&style=for-the-badge"
  /></a>
  <a href="https://github.com/Neelfrost/dotfiles/stargazers"
    ><img
      alt="stars"
      src="https://img.shields.io/github/stars/Neelfrost/dotfiles?colorA=151515&colorB=6A9FB5&style=for-the-badge&logo=starship"
  /></a>
  <a href="https://github.com/Neelfrost/dotfiles/network/members"
    ><img
      alt="forks"
      src="https://img.shields.io/github/forks/Neelfrost/dotfiles?colorA=151515&colorB=788C4C&style=for-the-badge&logo=github"
  /></a>
</p>

## Table of Contents <!-- omit in toc -->

- [Screenshots 📷](#screenshots-)
- [Installation ⚡](#installation-)
  - [LaTeX](#latex)
  - [Language Servers](#language-servers)
- [Update 🚀](#update-)
- [Features 📃](#features-)
  - [General](#general)
  - [LaTeX](#latex-1)
  - [Folder Structure](#folder-structure)
  - [Plugins Used](#plugins-used)
  - [Mappings](#mappings)
- [Todo ✔](#todo-)

## Screenshots 📷

![start](https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/start.png)
![time](https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/time.png)
![file explorer](https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/explorer.png)
![file navigation](https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/finder.png)
![latex](https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/tex.png)
![latex](https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/snippets.png)
![python](https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/python.png)

## Installation ⚡

The following instructions are for Windows (powershell). **An admin prompt is required.**

1. Install chocolatey.

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
   ```

2. Install main dependencies.

   ```
   choco install -y git.install --params "/GitAndUnixToolsOnPath /NoGitLfs /SChannel /NoShellIntegration";
   choco install -y neovim python SumatraPDF.install miktex.install;
   # Needed for various plugins
   choco install -y universal-ctags strawberryperl make SQLite ripgrep fd golang; refreshenv; exit
   ```

3. Install python dependencies.

   ```
   pip install pynvim neovim-remote
   ```

4. Clone the repository and open nvim-qt or nvim.

   For fresh installation:

   ```
   git clone https://github.com/Neelfrost/nvim-config.git "$HOME\Appdata\Local\nvim"; nvim-qt.exe
   ```

   For existing config:

   ```
   ren "$HOME\Appdata\Local\nvim" 'nvim-old'; git clone https://github.com/Neelfrost/nvim-config.git "$HOME\Appdata\Local\nvim"; nvim-qt.exe
   ```

### LaTeX

#### Formatting ([latexindent](https://github.com/cmhughes/latexindent.pl))

latexindent is now included with miktex, so downloading it separately is no longer necessary. Moreover, null-ls is pre-configured to run latexindent on save for tex files. Global formatting rules can be changed by:

1. Creating `$HOME/indentconfig.yaml`:

   ```yaml
   paths:
     - C:\Users\<username>\defaultSettings.yaml
   ```

2. Creating `$HOME/defaultSettings.yaml`, followed by copying and overriding [defaultSettings](https://github.com/cmhughes/latexindent.pl/blob/main/defaultSettings.yaml).

For further reading refer: [docs](https://latexindentpl.readthedocs.io/en/latest/sec-indent-config-and-settings.html).

#### Viewing PDF

To launch SumatraPDF using VimTeX (<kbd>\lv</kbd>), ensure `SumatraPDF.exe` is added to environment path.

```powershell
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path -Value $((Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path).path + ";" + "$HOME\AppData\Local\SumatraPDF" + ";"); refreshenv; exit
```

#### Inverse Search

For inverse search, open SumatraPDF then go to Settings -> Options and set inverse search command-line to:

```cmd
cmd /c start /min nvim --headless -c "PackerLoad vimtex" -c "VimtexInverseSearch %l '%f'"
```

Use `:checkhealth` to check for errors if any.

### Language Servers

#### Python ([pyright](https://github.com/microsoft/pyright))

1. Install npm.

   ```
   choco install -y nodejs.install; refreshenv; exit
   ```

2. Install pyright.

   ```
   npm install -g pyright
   ```

3. Install black, isort, and flake for formatting and linting.

   ```
   pip install flake8 black isort
   ```

4. Use `:checkhealth` to check for errors if any.

#### Lua ([LuaLs](https://github.com/LuaLS/lua-language-server))

1. Install dependencies.

   ```
   choco install -y 7zip.install; refreshenv; exit
   ```

2. cd into install directory. _For example:_

   ```
   cd C:\tools
   ```

3. Install LuaLs.

   ```powershell
   curl.exe -L $(curl.exe -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | findstr.exe "win32-x64" | %{"$($_.Split('"')[3])"} | findstr.exe "github") -o luals.zip; 7z.exe x .\luals.zip -olua-language-server; rm luals.zip
   ```

4. Add LuaLs to environment path.

   ```powershell
   Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path -Value $((Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path).path + ";" + "C:\tools\lua-language-server\bin" + ";"); refreshenv; exit
   ```

5. Install stylua for formatting.

   ```powershell
   curl.exe -L $(curl.exe -s https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest | findstr.exe "win64.zip" | %{"$($_.Split('"')[3])"} | findstr.exe "github") -o stylua-win64.zip; 7z.exe x -oC:\tools\stylua .\stylua-win64.zip; rm .\stylua-win64.zip;
   # Add stylua to environment path:
   Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path -Value $((Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path).path + ";" + "C:\tools\stylua" + ";"); refreshenv; exit
   ```

6. Use `:checkhealth` to check for errors if any.

#### C# ([omnisharp](https://github.com/omnisharp/omnisharp-roslyn))

1. Install dotnet-sdk.

   ```
   choco install dotnet-sdk -y
   ```

2. Install omnisharp-roslyn.

   ```
   curl.exe -L $(curl.exe -s https://api.github.com/repos/OmniSharp/omnisharp-roslyn/releases/latest | findstr.exe "omnisharp-win-x64-net6.0.zip" | %{"$($_.Split('"')[3])"} | findstr.exe "github") -o omnisharp-win-x64-net6.0.zip; 7z.exe x -oC:\tools\omnisharp .\omnisharp-win-x64-net6.0.zip; rm .\omnisharp-win-x64-net6.0.zip;
   ```

3. Use `:checkhealth` to check for errors if any.

#### HTML, CSS, Javascript ([vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted))

1. Install dependencies.

   ```
   npm i -g vscode-langservers-extracted
   ```

2. Install prettierd for formatting.

   ```
   npm i -g @fsouza/prettierd
   ```

3. Use `:checkhealth` to check for errors if any.

## Update 🚀

1. Pull changes.

   ```
   cd "$HOME\Appdata\Local\nvim"; git pull
   ```

2. Open nvim-qt or nvim and update plugins:

   ```
   :PackerSync
   ```

## Features 📃

### General

- Smart display line movement.
- Resume cursor position when re-opening a file.
- Auto update file if changed outside of neovim.
- Fix mixed indents (tabs are converted to spaces).
- Persistent cursor positions when switching buffers.
- Ability to search custom directories in telescope.nvim.
- Ability to reload specific modules using telescope.nvim.
- Automatically trim trailing whitespaces and newlines on save.
- Search and replace selection (automatically escape special chars).
- Open windows terminal, vscode, explorer at current directory using <kbd>\\\\t</kbd>, <kbd>\\\\c</kbd>, <kbd>\\\\e</kbd> respectively.

### LaTeX

<details>
    <summary>Compile status on statusline</summary>
    <figure>
        <figurecaption>Compile not started</figurecaption>
        <img
            src="https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/l1.webp"
            alt="Compile not started"
        />
        <figurecaption>Compile running</figurecaption>
        <img
            src="https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/l2.webp"
            alt="Compile running"
        />
        <figurecaption>Compile success</figurecaption>
        <img
            src="https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/l3.webp"
            alt="Compile success"
        />
        <figurecaption>Compile failed</figurecaption>
        <img
            src="https://raw.githubusercontent.com/Neelfrost/github-assets/main/dotfiles/l4.webp"
            alt="Compile failed"
        />
    </figure>
</details>

- Extensive snippets for LaTeX.
- Better auxiliary file cleaner.
- Null-ls: latexindent, chktex support.
- Automatically substitute `\` in imports (include, input) with `/` on save.
- Keybinds for bold, underline, math, chemical formula environments.
- Start newline with \item (or \task) if inside a list environment when pressing <kbd>Enter</kbd>, <kbd>o</kbd> or <kbd>O</kbd>.

### Folder Structure

```bash
nvim
├── after
│   └── ftplugin         # filetype specific options, settings, mappings
├── lua                  # .lua config files
│   └── user
│       └── mappings.lua # keybinds
│       └── options.lua  # vim options
│       └── utils.lua    # utility functions
│       └── plugins
│           ├── config   # plugin config
│           └── init.lua # plugin definition file
├── ultisnips            # snippets
│   └── tex              # latex snippets
└── viml                 # .vim config files
```

### Plugins

- Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim)

#### LSP

- LSP: [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
  - Diagnostics, formatting LSP: [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)
  - Python language server: [pyright](https://github.com/microsoft/pyright)
  - C# language server: [omnisharp](https://github.com/omnisharp/omnisharp-roslyn)
  - Lua language server: [LuaLs](https://github.com/LuaLS/lua-language-server)
  - HTML, CSS, Javascript language server: ([vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted))
  - Function signature when typing: [lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim)
  - Refactor functionality: [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim)
  - Backup code formatting: [neoformat](https://github.com/sbdchd/neoformat)

#### File navigation

- File explorer: [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- Fuzzy finder: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
  - Telescope frecency picker: [telescope-frecency.nvim](https://github.com/nvim-telescope/telescope-frecency.nvim)
  - Telescope fzf sorter: [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
  - Telescope ultisnips viewer: [telescope-ultisnips.nvim](https://github.com/fhill2/telescope-ultisnips.nvim)

#### Code completion

- Code completion: [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
  - Ultisnips source: [cmp-nvim-ultisnips](https://github.com/quangnguyen30192/cmp-nvim-ultisnips)
  - LSP source: [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
  - Buffer source: [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
  - Path source: [cmp-path](https://github.com/hrsh7th/cmp-path)
  - Cmdline source: [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
  - Omni source (for vimtex): [cmp-omni](https://github.com/hrsh7th/cmp-omni)

#### LaTeX

- LaTeX support: [vimtex](https://github.com/lervag/vimtex)
- Snippet engine: [ultisnips](https://github.com/SirVer/ultisnips)
- Tag management: [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)

#### Looks

- Theme support: [themer.lua](https://github.com/ThemerCorp/themer.lua)
- Indent lines: [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
- Thin virtual column: [virt-column.nvim](https://github.com/lukas-reineke/virt-column.nvim)
- Icons support: [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
- Syntax highlighting: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- Colored matching brackets: [nvim-ts-rainbow2](https://github.com/HiPhish/nvim-ts-rainbow2)
- Color preview: [vim-hexokinase](https://github.com/RRethy/vim-hexokinase)
- Prettier folds: [pretty-fold.nvim](https://github.com/anuvyklack/pretty-fold.nvim)

#### Buffer, Status

- Bufferline: [cokeline.nvim](https://github.com/noib3/cokeline.nvim)
- Statusline: [heirline.nvim](https://github.com/rebelot/heirline.nvim)

#### QOL

- Repeat actions: [vim-repeat](https://github.com/tpope/vim-repeat)
- Faster navigation: [hop.nvim](https://github.com/phaazon/hop.nvim)
- Better quickfix: [nvim-pqf](https://gitlab.com/yorickpeterse/nvim-pqf)
- Aligning: [vim-easy-align](https://github.com/junegunn/vim-easy-align)
- Commenting: [nvim-comment](https://github.com/terrortylor/nvim-comment)
- Toggle booleans & more: [alternate-toggler](https://github.com/rmagatti/alternate-toggler)
- Multiple cursors: [vim-visual-multi](https://github.com/mg979/vim-visual-multi)
- Title Case: [vim-titlecase](https://github.com/christoomey/vim-titlecase)
- Start screen: [alpha-nvim](goolord/alpha-nvim)
- Auto pair brackets: [auto-pairs](https://github.com/jiangmiao/auto-pairs)
- Bracket operations: [nvim-surround](https://github.com/kylechui/nvim-surround)
- Startup time: [vim-startuptime](https://github.com/dstein64/vim-startuptime)
- Fix cursorhold autocmd: [FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim)
- Fast expr folds: [FastFold](https://github.com/antoinemadec/Konfekt/FastFold)
- Markdown preview: [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
- Run commands asynchronously: [asyncrun.vim](https://github.com/skywind3000/asyncrun.vim)
- Session manager: [neovim-session-manager](https://github.com/Shatur/neovim-session-manager)
- Annotation generator: [neogen](https://github.com/danymat/neogen)

### Mappings

| Shortcut                  | Mode                 | Description                                        |
| ------------------------- | -------------------- | -------------------------------------------------- |
| <kbd>F2</kbd>             | Normal               | Replace word under cursor                          |
| <kbd>F2</kbd>             | Visual               | Rename selection                                   |
| <kbd>F5</kbd>             | Normal               | Open telescope.nvim module reloader                |
| <kbd>F10</kbd>            | Normal               | Toggle spellcheck                                  |
| <kbd>F11</kbd>            | Normal               | Toggle warp                                        |
| <kbd>F12</kbd>            | Normal               | Toggle paste mode                                  |
| <kbd>\\\\t</kbd>          | Normal               | Open windows terminal at cwd                       |
| <kbd>\\\\e</kbd>          | Normal               | Open explorer at cwd                               |
| <kbd>\\\\c</kbd>          | Normal               | Open current file in VSCode                        |
| <kbd>\\\\n</kbd>          | Normal               | Open current file in notepad                       |
| <kbd>tf</kbd>             | Normal               | Open telescope.nvim find files                     |
| <kbd>tr</kbd>             | Normal               | Open telescope.nvim recent files                   |
| <kbd>ts</kbd>             | Normal               | Open telescope.nvim session browser                |
| <kbd>\q</kbd>             | Normal               | Toggle quickfix                                    |
| <kbd>\h</kbd>             | Normal               | Disable search highlight                           |
| <kbd>\v</kbd>             | Normal/Insert        | Paste from system clipboard in **paste** mode      |
| <kbd>\w</kbd>             | Normal               | Close buffer _(will discard changes if not saved)_ |
| <kbd>\u</kbd>             | Normal               | Open URL under cursor in browser                   |
| <kbd>\s</kbd>             | Normal               | Search word under cursor in browser                |
| <kbd>\n</kbd>             | Normal               | Open dashboard                                     |
| <kbd>f</kbd>              | Normal               | Search buffer using 1 chars                        |
| <kbd>S</kbd>              | Normal               | Search buffer using 2 chars                        |
| <kbd>Tab</kbd>            | Normal               | Move to next buffer                                |
| <kbd>Shift Tab</kbd>      | Normal               | Move to previous buffer                            |
| <kbd>Tab</kbd>            | Insert               | Expand trigger or jump to next tab stop            |
| <kbd>Shift Tab</kbd>      | Insert               | Jump to previous tab stop                          |
| <kbd>Ctrl j(k)</kbd>      | Command              | Move between completion items                      |
| <kbd>Ctrl j(k)</kbd>      | Insert               | Move between completion items                      |
| <kbd>Alt d</kbd>          | Normal               | Duplicate current line below                       |
| <kbd>Alt j(k)</kbd>       | Normal/Visual        | Move line (block) up or down                       |
| <kbd>Alt ]</kbd>          | Normal               | Increase indent                                    |
| <kbd>Alt [</kbd>          | Normal               | Decrease indent                                    |
| <kbd>Ctrl /</kbd>         | Normal/Visual/Insert | Comment current (selected) line(s)                 |
| <kbd>Enter</kbd>          | Insert               | Select completion item                             |
| <kbd>Ctrl Space</kbd>     | Insert               | Force completion menu to open                      |
| <kbd>Ctrl c</kbd>         | Insert               | Force completion menu to close                     |
| <kbd>Ctrl e</kbd>         | Insert               | Select first completion item                       |
| <kbd>Ctrl t</kbd>         | Insert               | Open omni-func completion                          |
| <kbd>Ctrl Backspace</kbd> | Insert               | Delete previous word                               |
| <kbd>Ctrl Delete</kbd>    | Insert               | Delete next word                                   |
| <kbd>Ctrl b</kbd>         | Normal               | Toggle nvim-tree                                   |
| <kbd>Ctrl f</kbd>         | Normal               | Format document                                    |
| <kbd>Ctrl h(jkl)</kbd>    | Normal               | Move to window to the left (down, up, right)       |
| <kbd>Ctrl s</kbd>         | Normal               | Save current file                                  |
| <kbd>Ctrl Shift s</kbd>   | Normal               | Save and reload module (current file)              |
| <kbd>Ctrl v</kbd>         | Insert               | Paste from system clipboard                        |
| <kbd>Ctrl z</kbd>         | Insert               | Correct preceding misspelt word                    |
| <kbd>Ctrl z</kbd>         | Normal               | Correct misspelt word under cursor                 |
| <kbd>gD</kbd>             | Normal               | LSP: Goto function declaration                     |
| <kbd>gi</kbd>             | Normal               | LSP: Goto function implementation                  |
| <kbd>gh</kbd>             | Normal               | LSP: Preview documentation                         |
| <kbd>gd</kbd>             | Normal               | LSP: Preview function definition                   |
| <kbd>gs</kbd>             | Normal               | LSP: Preview signature help                        |
| <kbd>gr</kbd>             | Normal               | LSP: Rename instance                               |
| <kbd>gl</kbd>             | Normal               | LSP: Show line diagnostic                          |
| <kbd>gR</kbd>             | Normal               | LSP: Show references                               |
| <kbd>ga</kbd>             | Normal               | LSP: Trigger code action                           |
| <kbd>\li</kbd>            | Normal               | VimTeX: Info                                       |
| <kbd>\lT</kbd>            | Normal               | VimTeX: TOC toggle                                 |
| <kbd>\lq</kbd>            | Normal               | VimTeX: Log                                        |
| <kbd>\lv</kbd>            | Normal               | VimTeX: View pdf                                   |
| <kbd>\lr</kbd>            | Normal               | VimTeX: Reverse search                             |
| <kbd>\ll</kbd>            | Normal               | VimTeX: Compile                                    |
| <kbd>\lk</kbd>            | Normal               | VimTeX: Stop                                       |
| <kbd>\le</kbd>            | Normal               | VimTeX: Errors                                     |
| <kbd>\lC</kbd>            | Normal               | VimTeX: Clean full                                 |
| <kbd>\lx</kbd>            | Normal               | VimTeX: Reload                                     |
| <kbd>\lX</kbd>            | Normal               | VimTeX: Reload state                               |
| <kbd>\t</kbd>             | Normal               | Python, Lua, C#: Run code in external terminal     |
| <kbd>\r</kbd>             | Normal               | Python, Lua: Run code without terminal output      |
| <kbd>\lt</kbd>            | Normal               | Lua (LÖVE2D): Run game in external terminal        |
| <kbd>\lr</kbd>            | Normal               | Lua (LÖVE2D): Run game without terminal output     |

## Todo ✔

- [ ] Improve mappings table
- [ ] Document snippets
- [ ] Automatic install script
- [ ] Create video to showcase snippets
