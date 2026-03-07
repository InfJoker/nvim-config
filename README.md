# Neovim Config

Personal Neovim configuration. Pure Lua, managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## Prerequisites

| Dependency | Notes |
|---|---|
| [Neovim](https://neovim.io/) >= 0.11 | Required |
| [Git](https://git-scm.com/) | Required |
| [Nerd Font](https://www.nerdfonts.com/) | Required for icons |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Recommended (Telescope live grep) |
| [fd](https://github.com/sharkdp/fd) | Recommended (Telescope file finder) |
| C compiler (`gcc`/`clang`) | Recommended (Treesitter parsers) |
| [Node.js](https://nodejs.org/) + npm | Recommended (some LSP servers) |
| Python 3 + pip | Recommended (some LSP servers) |

## Quick Install

```bash
bash <(curl -s https://raw.githubusercontent.com/InfJoker/nvim-config/main/install.sh)
```

## Manual Install

```bash
# Back up existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone https://github.com/InfJoker/nvim-config.git ~/.config/nvim

# Launch — plugins and LSP servers install automatically
nvim
```

<!-- Screenshot placeholder: add a screenshot here -->
