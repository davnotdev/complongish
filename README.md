# Comp-longish

Autocomplete Long-ish words in neovim.

I may also put other micro-plugins here.

## Usage

```lua

-- `complongish` only functions in insert mode.
vim.api.nvim_set_keymap('i', '<C-l>', [[<Cmd>:lua require('complongish').complongish()<CR>]], { noremap = true, silent = true })

```

