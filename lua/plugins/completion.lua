
return {
  {
    "saghen/blink.cmp",
    version = "1.*",

    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    opts = {
      keymap = {
        preset = "default",

        -- Enter accepts the selected suggestion.
        -- Otherwise, inserts a normal newline.
        ["<CR>"] = {
          "select_and_accept",
          "fallback",
        },

        -- Tab accepts suggestions, advances snippets,
        -- or performs normal indentation.
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },

        -- Shift+Tab goes to the previous snippet placeholder.
        ["<S-Tab>"] = {
          "snippet_backward",
          "fallback",
        },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
        },

        ghost_text = {
          enabled = true,
        },

        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
      },

      signature = {
        enabled = true,
      },

      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },

    opts_extend = {
      "sources.default",
    },
  },
}
