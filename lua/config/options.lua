local opt = vim.opt

-- Appearance / navigation
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.termguicolors = true
opt.showmode = false
opt.laststatus = 3
opt.splitbelow = true
opt.splitright = true
opt.pumheight = 12
opt.winborder = "rounded"

opt.fillchars = {
	eob = " ",
	fold = " ",
	foldopen = "▾",
	foldclose = "▸",
}

-- Editing
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.breakindent = true
opt.undofile = true
opt.swapfile = false
opt.confirm = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Faster editor updates
opt.updatetime = 250
opt.timeoutlen = 400

-- Completion
opt.completeopt = {
	"menu",
	"menuone",
	"noselect",
}

-- Whitespace
opt.list = true
opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}

-- Folding
opt.spell = false
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = false

-- Diagnostics
vim.diagnostic.config({
	severity_sort = true,

	-- Keep errors and warnings updated while typing.
	update_in_insert = true,

	underline = true,

	virtual_text = {
		spacing = 3,
		source = "if_many",
	},

	float = {
		border = "rounded",
		source = true,
	},

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "󰌵",
			[vim.diagnostic.severity.INFO] = "●",
		},
	},
})
