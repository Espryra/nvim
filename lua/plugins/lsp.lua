return {
  {
    "mason-org/mason.nvim",
    opts = { ui = { border = "rounded" } },
  },
  { "neovim/nvim-lspconfig" },
  { "b0o/SchemaStore.nvim" },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "b0o/SchemaStore.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      ensure_installed = {
        "lua_ls",                        -- Neovim Lua
        "vtsls",                         -- TypeScript, JavaScript, React/TSX, Next.js
        "eslint",                        -- TS/JS projects with ESLint configuration
        "gopls",                         -- Go, go.mod, go.work
        "dockerls",                      -- Dockerfiles
        "docker_compose_language_service", -- Docker Compose
        "jsonls",                        -- JSON, JSONC, package.json, tsconfig.json
        "yamlls",                        -- YAML, workflows
        "taplo",                         -- TOML
        "bashls",                        -- Bash and shell scripts
        "html",                          -- HTML
        "cssls",                         -- CSS/SCSS/Less
        "marksman",                      -- Markdown
        "pyright",                       -- Python
        "intelephense",                  -- PHP
        "sqls",                          -- SQL, MySQL (see README for connection config)
      },
      automatic_enable = true,
    },
    config = function(_, opts)
      -- Neovim 0.12: use the native config/enable API, not lspconfig.X.setup().
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            validate = { enable = true },
            schemas = require("schemastore").json.schemas(),
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            validate = true,
            hover = true,
            completion = true,
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      -- Keep SQL support available in Git projects even without sqls config.yml.
      -- For DB-specific completion, configure a connection separately.
      vim.lsp.config("sqls", { root_markers = { "config.yml", ".git" } })

      require("mason-lspconfig").setup(opts)
    end,
  },
}
