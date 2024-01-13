# Personal nvim Configuration README

## Configuration Overview

### init.lua Overview

- Provides a function `RegisterWK`, to simplify the registration of key mappings with meaningful
  descriptions.
- Sets **Global Leader Key** (spacebar = ` `) and **Local Leader Key** (backslash = `\`).
- Bootstraps lazy.nvim.
- Loads lua Neovim core configurations.
- Loads community plugins via lazy.nvim.
- Loads other custom key mappings are defined in `mappings`.

### [./plugin/](./plugin/) Overview

This folder contains all the filetype-specific configurations like additional setup for LSP,
debugging, etc.

### [./lua/\*.lua](./lua/) Overview

The top-level `*.lua` files in this directory are base configurations for Neovim that don't introduce
or use any community plugins (not including the `which-key` plugin for convenient mapping
definition).

### [./lua/plugins/\*.lua](./lua/plugins/) Overview

The top-level `*.lua` files in this directory introduce community plugins configurations. The
community plugins are separated into different lua files by their _functionality_ i.e. debugging and
REPL, git, etc.
