
local parsers = {
  "bash",
  "c",
  "css",
  "diff",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({})

      -- Filetype to parser mappings
      vim.treesitter.language.register("json", "jsonc")
      vim.treesitter.language.register("yaml", "yaml.docker-compose")

      -- Install supported parsers asynchronously
      treesitter.install(parsers)

      -- Enable Tree-sitter highlighting
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash", "sh", "css", "dockerfile",
          "go", "gomod", "gosum", "gowork",
          "html", "javascript", "javascriptreact",
          "json", "jsonc", "lua", "markdown",
          "python", "toml", "typescript",
          "typescriptreact", "vim", "vimdoc",
          "yaml", "yaml.docker-compose",
        },

        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Handle the currently open buffer
      vim.schedule(function()
        local bufnr = vim.api.nvim_get_current_buf()

        if vim.bo[bufnr].filetype ~= "" then
          pcall(vim.treesitter.start, bufnr)
        end
      end)
    end,
  },
}