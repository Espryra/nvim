return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "prettierd",
        "goimports",
        "gofumpt",
        "shfmt",
        "taplo",
        "ruff",
        "shellcheck",
        "hadolint",
      },
      run_on_start = true,
      auto_update = false,
      debounce_hours = 24,
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        ["yaml.docker-compose"] = { "prettierd" },
        toml = { "taplo" },
        markdown = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        less = { "prettierd" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        python = { "ruff_format" },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return nil
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
      notify_on_error = true,
      notify_no_formatters = false,
      formatters = { shfmt = { append_args = { "-i", "2" } } },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end, { desc = "Format the current buffer" })
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "Disable format-on-save; use ! for current buffer", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function(args)
        if args.bang then
          vim.b.disable_autoformat = false
        else
          vim.g.disable_autoformat = false
        end
      end, { desc = "Enable format-on-save; use ! for current buffer", bang = true })
    end,
  },
}
