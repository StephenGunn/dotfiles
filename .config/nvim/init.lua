-- Set the path where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is not installed, and clone it if necessary
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Use the latest stable release
    lazypath,
  })
end

-- Prepend lazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

-- Load custom vim options from a separate file
require("vim-options")

-- Auto load plugins from the 'plugins' directory
require("lazy").setup("plugins")

-- Set the Python 3 interpreter for Neovim
vim.g.python3_host_prog = "/usr/bin/python3"
