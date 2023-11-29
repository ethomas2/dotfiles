--
vim.cmd.source("/Users/evanthomas/.config/nvim/_init.vim")

------------------------------------ Lazy Setup ---------------------------------
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--   vim.fn.system({
--     "git",
--     "clone",
--     "--filter=blob:none",
--     "https://github.com/folke/lazy.nvim.git",
--     "--branch=stable", -- latest stable release
--     lazypath,
--   })
-- end
-- vim.opt.rtp:prepend(lazypath)

---------------------------------------------------------------------------------

-- require("lazy").setup({
--   "jackMort/ChatGPT.nvim",
--     event = "VeryLazy",
--     config = function()
--       require("chatgpt").setup()
--     end,
--     dependencies = {
--       "MunifTanjim/nui.nvim",
--       "nvim-lua/plenary.nvim",
--       "nvim-telescope/telescope.nvim"
--     }
-- }, opts)
