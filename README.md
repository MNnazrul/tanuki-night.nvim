<h1 align="center">🦝 tanuki-night</h1>

<p align="center">
  GitLab's dark syntax theme for Neovim and Vim — the Tomorrow Night palette with GitLab's own token rules.
</p>

<p align="center">
  <a href="https://github.com/MNnazrul/tanuki-night.nvim/actions/workflows/ci.yml"><img src="https://github.com/MNnazrul/tanuki-night.nvim/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <img src="https://img.shields.io/badge/Neovim-0.9%2B-57A143?logo=neovim&logoColor=white" alt="Neovim 0.9+">
  <img src="https://img.shields.io/badge/license-MIT-81a2be" alt="MIT">
</p>

![tanuki-night](assets/hero.png)

If you read a lot of code in GitLab merge requests, your editor can look the same.
tanuki-night was matched **token by token** against GitLab screenshots: which words are
purple, which are yellow, which stay plain — per language, not just the palette.

## ✨ Features

- GitLab dark token rules for **C, C++, Rust, Zig, Python, Lua, Go, JavaScript/TypeScript, Ruby, Bash, CSS/SCSS, YAML, TOML, JSON, Makefile, HTML**
- Any other language still gets the full Tomorrow Night look through generic Treesitter and Vim syntax groups
- GitLab UI details: purple current line number, merge request diff colors, orange search/line target
- LSP semantic tokens are tamed so Treesitter keeps the GitLab look
- Plugin support (see [below](#-plugin-support))
- Works in **Vim** too (generated `colors/tanuki-night.vim`)
- Extras for **NvChad**, **lualine**, **kitty**, **Ghostty**, **Alacritty**, **WezTerm**

## ⚡️ Requirements

- Neovim **0.9+** (or Vim 8+)
- A terminal with truecolor support (`termguicolors`)
- Optional: Treesitter parsers for your languages (`:TSInstall c rust go …`) for the most accurate colors

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "MNnazrul/tanuki-night.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("tanuki-night")
  end,
}
```

### Built-in `vim.pack` (Neovim 0.12+)

```lua
vim.pack.add({ "https://github.com/MNnazrul/tanuki-night.nvim" })
vim.cmd.colorscheme("tanuki-night")
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use("MNnazrul/tanuki-night.nvim")
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'MNnazrul/tanuki-night.nvim'
```

### Vim (native packages)

```sh
git clone https://github.com/MNnazrul/tanuki-night.nvim ~/.vim/pack/themes/start/tanuki-night
```

## 🚀 Usage

```vim
colorscheme tanuki-night
```

```lua
vim.cmd.colorscheme("tanuki-night")
```

## ⚙️ Configuration

Call `setup()` **before** loading the colorscheme. Defaults:

```lua
require("tanuki-night").setup({
  transparent = false,       -- no background on Normal, SignColumn, ...
  terminal_colors = true,    -- set vim.g.terminal_color_0..15
  gitlab_cursorline = false, -- GitLab's orange "#L" line as CursorLine
  dim_inactive = false,      -- darker background for inactive windows
  styles = {                 -- any nvim_set_hl() attributes
    comments = {},           -- e.g. { italic = true }
    keywords = {},
    functions = {},
    strings = {},
  },
  on_colors = function(colors) end,
  on_highlights = function(hl, colors) end,
})
```

### Overriding colors and groups

```lua
require("tanuki-night").setup({
  on_colors = function(c)
    c.comment = "#7f8180"
  end,
  on_highlights = function(hl, c)
    hl.CursorLine = { bg = c.bg_alt2 }
    hl["@variable.parameter"] = "@variable" -- a string links to another group
  end,
})
```

Use the palette in your own config:

```lua
local c = require("tanuki-night").colors()
```

Full docs: `:help tanuki-night`.

## 🎨 Palette

| | | | |
|---|---|---|---|
| ![](https://placehold.co/16x16/1d1f21/1d1f21.png) `bg` `#1d1f21` | ![](https://placehold.co/16x16/c5c8c6/c5c8c6.png) `fg` `#c5c8c6` | ![](https://placehold.co/16x16/969896/969896.png) `comment` `#969896` | ![](https://placehold.co/16x16/2e3a4a/2e3a4a.png) `visual` `#2e3a4a` |
| ![](https://placehold.co/16x16/cc6666/cc6666.png) `red` `#cc6666` | ![](https://placehold.co/16x16/de935f/de935f.png) `orange` `#de935f` | ![](https://placehold.co/16x16/f0c674/f0c674.png) `yellow` `#f0c674` | ![](https://placehold.co/16x16/b5bd68/b5bd68.png) `green` `#b5bd68` |
| ![](https://placehold.co/16x16/8abeb7/8abeb7.png) `aqua` `#8abeb7` | ![](https://placehold.co/16x16/81a2be/81a2be.png) `blue` `#81a2be` | ![](https://placehold.co/16x16/b294bb/b294bb.png) `purple` `#b294bb` | ![](https://placehold.co/16x16/453793/453793.png) `cursor nr` `#453793` |

## 🖼 Gallery

<details>
<summary>C</summary>

![C](assets/c.png)
</details>

<details>
<summary>Go</summary>

![Go](assets/go.png)
</details>

<details>
<summary>TypeScript</summary>

![TypeScript](assets/typescript.png)
</details>

<details>
<summary>Lua</summary>

![Lua](assets/lua.png)
</details>

## 🔌 Plugin support

[gitsigns](https://github.com/lewis6991/gitsigns.nvim) ·
[telescope](https://github.com/nvim-telescope/telescope.nvim) ·
[fzf-lua](https://github.com/ibhagwan/fzf-lua) ·
[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) ·
[blink.cmp](https://github.com/Saghen/blink.cmp) ·
[nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) ·
[neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) ·
[oil](https://github.com/stevearc/oil.nvim) ·
[indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) ·
[mini.nvim](https://github.com/echasnovski/mini.nvim) ·
[snacks](https://github.com/folke/snacks.nvim) ·
[which-key](https://github.com/folke/which-key.nvim) ·
[lazy.nvim](https://github.com/folke/lazy.nvim) ·
[mason](https://github.com/williamboman/mason.nvim) ·
[noice](https://github.com/folke/noice.nvim) ·
[nvim-notify](https://github.com/rcarriga/nvim-notify) ·
[trouble](https://github.com/folke/trouble.nvim) ·
[flash](https://github.com/folke/flash.nvim) ·
[leap](https://github.com/ggandor/leap.nvim) ·
[render-markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim) ·
[vim-illuminate](https://github.com/RRethy/vim-illuminate) ·
[neogit](https://github.com/NeogitOrg/neogit) ·
[diffview](https://github.com/sindrets/diffview.nvim) ·
[treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) ·
[lualine](https://github.com/nvim-lualine/lualine.nvim)

## 🍭 Extras

| Tool | File | How |
|---|---|---|
| lualine | built in | `require("lualine").setup({ options = { theme = "tanuki-night" } })` |
| NvChad | [`extras/nvchad/tanuki-night.lua`](extras/nvchad/tanuki-night.lua) | copy to `~/.config/nvim/lua/themes/`, pick with `<leader>th` |
| kitty | [`extras/kitty/tanuki-night.conf`](extras/kitty/tanuki-night.conf) | `include tanuki-night.conf` in `kitty.conf` |
| Ghostty | [`extras/ghostty/tanuki-night`](extras/ghostty/tanuki-night) | copy to `~/.config/ghostty/themes/`, set `theme = tanuki-night` |
| Alacritty | [`extras/alacritty/tanuki-night.toml`](extras/alacritty/tanuki-night.toml) | `general.import = ["…/tanuki-night.toml"]` |
| WezTerm | [`extras/wezterm/tanuki-night.toml`](extras/wezterm/tanuki-night.toml) | copy to a `color_schemes_dirs` folder, `color_scheme = "tanuki-night"` |

> NvChad users who want the Rust/Go query tweaks too: also install the plugin (lazy spec above, without `config`).

## 🧪 Development

```sh
make gen    # regenerate colors/tanuki-night.vim and everything in extras/
make test   # headless smoke tests
make fmt    # stylua
```

Never edit generated files by hand — change `lua/tanuki-night/` and run `make gen`.

To check a token's final color without opening Neovim:

```sh
nvim --headless -u NONE -l scripts/inspect.lua tests/samples/sample.c ~/.local/share/nvim/site
```

Found a color that differs from GitLab? [Open an issue](https://github.com/MNnazrul/tanuki-night.nvim/issues/new/choose)
with a GitLab screenshot of the same code.

## 🙏 Credits

- [Tomorrow Night](https://github.com/chriskempson/tomorrow-theme) by Chris Kempson — the palette
- GitLab's dark syntax highlighting theme — the token rules and UI colors
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) — structure inspiration

tanuki-night is not affiliated with or endorsed by GitLab Inc.

## License

[MIT](LICENSE)
