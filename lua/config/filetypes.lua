-- Docker Compose's language server only attaches to yaml.docker-compose.
-- Neovim often recognizes these filenames already; explicitly cover all four.
vim.filetype.add({
  filename = {
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    [".prettierrc"] = "json",
    [".eslintrc"] = "json",
  },
  pattern = {
    [".*[/]compose[%.%-].*%.ya?ml"] = "yaml.docker-compose",
    [".*[/]docker%-compose[%.%-].*%.ya?ml"] = "yaml.docker-compose",
  },
})
