# Neovim 0.12.x developer workspace

A modular Neovim base for Arch Linux: polished dark UI, Telescope, Neo-tree,
Mason LSPs, Blink completion, Treesitter, autoformatting, linting, and Git.
**Global custom keymaps are intentionally postponed.** This setup uses
Neovim defaults, plugin-native bindings, dashboard shortcuts, and commands.

## Prerequisites (Arch Linux)

```bash
sudo pacman -S --needed git base-devel cmake curl unzip tar gzip \
  ripgrep fd nodejs npm go tree-sitter-cli wl-clipboard
```

Recommended: use a **Nerd Font** for your terminal (icons are optional).
You need Internet access for the first bootstrap and Mason tool installs.

## Install without overwriting your old config

Back up your current configuration first:

```bash
mv ~/.config/nvim ~/.config/nvim.backup-$(date +%Y%m%d-%H%M%S)  # if it exists
mkdir -p ~/.config/nvim
cp -a ./nvim-base/. ~/.config/nvim/
nvim
```

Run the copy command from the directory containing `nvim-base/`, or copy the
contents of the provided archive's `nvim-base/` folder to `~/.config/nvim`.

At first boot, `lazy.nvim` clones plugins, `mason-lspconfig.nvim` queues the
selected LSP installations, `mason-tool-installer` installs formatters/linters,
and Treesitter installs parsers asynchronously. Some language tools need
Node/npm, Go, or native compilers (the Arch command above provides these).
Mason installations may need an additional Neovim restart before they attach.

## Commands you can use immediately

- `:Lazy` / `:Lazy update` — manage or update plugins
- `:Mason` — inspect or install language servers/tools
- `:MasonToolsInstall` — install any missing formatters/linters
- `:Telescope find_files` — find files
- `:Telescope live_grep` — project-wide search (requires ripgrep)
- `:Telescope buffers` / `:Telescope oldfiles` — jump around
- `:Neotree toggle` — file explorer
- `:Trouble diagnostics toggle` — diagnostics list
- `:TodoTelescope` — find TODO/FIXME comments with Telescope
- `:Format` / `:ConformInfo` — format and inspect formatter
- `:FormatDisable`, `:FormatEnable` — toggle format-on-save globally
- `:FormatDisable!`, `:FormatEnable!` — per-buffer overrides
- `:LspStatus` / `:checkhealth vim.lsp` — inspect LSP status and health
- `:checkhealth` — diagnose dependencies
- `:TSUpdate` — update Treesitter parsers; reopen buffer if first install just finished

Default Neovim 0.12 LSP mappings include `K` for hover, `grn` for rename,
`gra` for code actions, `grr` for references, and `Ctrl-]` for definitions.
They may coexist with plugin-defined defaults; custom mappings come next.
Blink completion uses Ctrl-Space to open completion, Ctrl-Y to accept,
and Ctrl-N/Ctrl-P to select entries. Dashboard keys only apply on dashboard.

## Included language servers

| Language/file | LSP | Formatting / tooling |
|---|---|---|
| TypeScript, TSX, JavaScript, JSX, Next.js | `vtsls`, `eslint` | `prettierd` |
| Go, go.mod, go.work | `gopls` | `goimports`, `gofumpt` |
| Dockerfile | `dockerls` | `hadolint` linter |
| Docker Compose files | `docker_compose_language_service` | `prettierd` |
| JSON, JSONC, tsconfig, package.json | `jsonls` + SchemaStore | `prettierd` |
| YAML, GitHub Actions | `yamlls` + SchemaStore | `prettierd` |
| TOML | `taplo` | `taplo` |
| Bash/sh | `bashls` | `shfmt`, `shellcheck` |
| Lua/Neovim config | `lua_ls` | `stylua` |
| HTML, CSS, SCSS | `html`, `cssls` | `prettierd` |
| Markdown | `marksman` | `prettierd` |
| Python | `pyright` | `ruff format` |
| PHP | `intelephense` | LSP fallback if provided |
| SQL / MySQL | `sqls` | SQL LSP; database config needed for DB-aware completion |

`sqls` requires a separately configured database connection for schema-aware
MySQL completion; it does not connect to your database automatically.

For TS/JS, keep your project's dependencies installed (e.g. `bun install`).
`eslint` only works fully in projects that have ESLint configured.
`vtsls` is the only TS language server enabled by this config, to avoid
conflicts with `ts_ls` and the new TS7 `tsc` server.

## Layout

```text
init.lua
lua/config/
  options.lua      UI/editor defaults
  filetypes.lua    Compose file detection
  autocmds.lua     small, safe editing automations
  commands.lua     commands (no custom leader mappings)
  lazy.lua         plugin manager bootstrap
lua/plugins/
  ui.lua           theme, dashboard, statusline, tabs, explorer
  editor.lua       Telescope, Git, comments, diagnostics, pairs
  completion.lua   stable Blink completion
  lsp.lua          Mason + native Neovim LSP + schemas
  treesitter.lua   new 0.12+ Tree-sitter API
  formatting.lua   Conform and formatter packages
  lint.lua         ShellCheck + Hadolint
```

For the next phase, add `lua/config/keymaps.lua` then load it at the
end of `init.lua`. This keeps keybindings isolated from plugin setup.

## Troubleshooting

- `:checkhealth lazy`, `:checkhealth mason`, `:checkhealth nvim-treesitter`,
  `:checkhealth vim.lsp`, and `:ConformInfo` are the first places to check.
- On the initial Treesitter install, wait for parser installation to finish
  in Neovim, then reopen a file to activate highlights.
- Docker Compose needs filetype `yaml.docker-compose`; verify with
  `:set filetype?` in `compose.yaml` or `docker-compose.yml`.
- To stop automatic formatting in a particular buffer, run `:FormatDisable!`.
- Some plugin versions may evolve; test updates with `:Lazy update` and
  check `:Lazy log` before committing an updated lock file.
