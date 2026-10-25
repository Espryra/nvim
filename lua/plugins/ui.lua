
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
      },
      on_highlights = function(highlights, colors)
        highlights.CursorLineNr = {
          fg = colors.orange,
          bold = true,
        }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = {
          left = "│",
          right = "│",
        },
        section_separators = {
          left = "",
          right = "",
        },
        disabled_filetypes = {
          statusline = {
            "dashboard",
            "alpha",
            "neo-tree",
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          "diagnostics",
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = " ●",
              readonly = " ",
            },
          },
        },
        lualine_x = {
          "encoding",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Files",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",

      filesystem = {
        follow_current_file = {
          enabled = true,
        },

        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          show_hidden_count = false,

          -- Common folders to hide
          hide_by_name = {
            -- Git
            ".git",

            -- Node.js / JavaScript
            "node_modules",
            "bower_components",
            ".pnpm-store",
            ".npm",
            ".yarn",
            ".next",
            ".nuxt",
            ".output",
            ".turbo",
            ".svelte-kit",
            ".parcel-cache",

            -- Build output
            "dist",
            "build",
            "out",
            "target",
            "coverage",
            ".nyc_output",

            -- Python
            "__pycache__",
            ".venv",
            "venv",
            ".pytest_cache",
            ".mypy_cache",
            ".ruff_cache",

            -- Java / IDE
            ".gradle",
            ".idea",
            ".settings",

            -- General caches
            ".cache",
            ".temp",
            ".tmp",

            -- Infrastructure
            ".terraform",

            -- OS files
            ".DS_Store",
            "Thumbs.db",
            "desktop.ini",
          },

          -- Generated files
          hide_by_pattern = {
            "*.pyc",
            "*.pyo",
            "*.class",
            "*.swp",
            "*.swo",
            "*~",
          },
        },

        hijack_netrw_behavior = "open_default",
      },

      window = {
        width = 34,
        position = "left",
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
      },
    },
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = "hyper",
      config = {
        header = {
          "",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██╔████╔██║",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═╝╚═╝     ╚═╝",
          "",
          "                 developer workspace",
          "",
        },
        shortcut = {
          {
            desc = "  Find files",
            group = "DiagnosticHint",
            action = "Telescope find_files",
            key = "f",
          },
          {
            desc = "  Search text",
            group = "String",
            action = "Telescope live_grep",
            key = "g",
          },
          {
            desc = "  Recent files",
            group = "Special",
            action = "Telescope oldfiles",
            key = "r",
          },
          {
            desc = "  Plugins",
            group = "Identifier",
            action = "Lazy",
            key = "p",
          },
        },
        project = {
          enable = false,
        },
        mru = {
          limit = 8,
        },
        footer = {
          "Neovim 0.12+  •  Developer workspace",
        },
      },
    },
  },
}
