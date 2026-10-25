return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "➜ ",
          sorting_strategy = "ascending",
          layout_config = { horizontal = { prompt_position = "top", preview_width = 0.57 } },
          file_ignore_patterns = { "node_modules/", "%.git/", "dist/", "%.next/", "target/", "vendor/" },
          path_display = { "smart" },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })
      telescope.load_extension("fzf")
    end,
  },
  { "lewis6991/gitsigns.nvim", opts = { current_line_blame = false, signcolumn = true } },
  { "numToStr/Comment.nvim", opts = {} },
  {
    "echasnovski/mini.pairs",
    version = false,
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
  },
  { "folke/trouble.nvim", opts = {} },
  {
    "j-hui/fidget.nvim",
    opts = { notification = { window = { winblend = 0 } } },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "modern" }, -- ready for custom keymaps in the next phase
  },
}
