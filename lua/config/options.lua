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

-- Editor responsiveness
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

-----------------------------------------------------------
-- Diagnostic word wrapping
-----------------------------------------------------------

-- Calculate available diagnostic width for a buffer.
-- Accounts for line numbers, signs and diagnostic indentation.
local function diagnostic_width(diagnostic)
	local bufnr = diagnostic.bufnr
	local indent = 0

	if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
		local lnum = diagnostic.lnum or 0

		if lnum < vim.api.nvim_buf_line_count(bufnr) then
			local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""

			local before = line:sub(1, diagnostic.col or 0)

			indent = vim.fn.strdisplaywidth(before)
		end
	end

	local width = nil

	if bufnr then
		for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
			if vim.api.nvim_win_is_valid(win) then
				local info = vim.fn.getwininfo(win)[1]

				local gutter = info and info.textoff or 0

				-- Reserve space for the diagnostic connector.
				local available = vim.api.nvim_win_get_width(win) - gutter - indent - 8

				if not width or available < width then
					width = available
				end
			end
		end
	end

	return math.max(12, width or (vim.o.columns - indent - 16))
end

-- Wrap text at word boundaries.
-- Long words are split if necessary.
local function wrap_paragraph(text, width)
	local lines = {}
	local current = ""

	for word in text:gmatch("%S+") do
		local candidate = current == "" and word or current .. " " .. word

		if vim.fn.strdisplaywidth(candidate) <= width then
			current = candidate
		else
			if current ~= "" then
				table.insert(lines, current)
				current = ""
			end

			-- Split very long words or paths.
			local piece = ""

			for i = 0, vim.fn.strchars(word) - 1 do
				local char = vim.fn.strcharpart(word, i, 1)

				if piece ~= "" and vim.fn.strdisplaywidth(piece .. char) > width then
					table.insert(lines, piece)
					piece = char
				else
					piece = piece .. char
				end
			end

			current = piece
		end
	end

	if current ~= "" then
		table.insert(lines, current)
	end

	return lines
end

-- Format diagnostics into multiple virtual lines.
local function format_diagnostic(diagnostic)
	local width = diagnostic_width(diagnostic)

	local message = diagnostic.message:gsub("\r", "")

	-- Preserve diagnostic codes, e.g. DL3027.
	if diagnostic.code then
		message = tostring(diagnostic.code) .. ": " .. message
	end

	local result = {}

	-- Preserve existing multiline diagnostics.
	for _, paragraph in ipairs(vim.split(message, "\n", { plain = true })) do
		local lines = wrap_paragraph(paragraph, width)

		for _, line in ipairs(lines) do
			table.insert(result, line)
		end
	end

	return table.concat(result, "\n")
end

-----------------------------------------------------------
-- Diagnostics
-----------------------------------------------------------

vim.diagnostic.config({
	severity_sort = true,

	-- Update errors while typing.
	update_in_insert = true,

	-- Highlight affected code.
	underline = true,

	-- Disable single-line inline diagnostic text.
	virtual_text = false,

	-- Show wrapped diagnostics below the current line.
	virtual_lines = {
		current_line = true,
		format = format_diagnostic,
	},

	-- Floating diagnostic windows.
	float = {
		border = "rounded",
		source = true,
		focusable = true,
		wrap = true,
	},

	-- Diagnostic signs.
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "󰌵",
			[vim.diagnostic.severity.INFO] = "●",
		},
	},
})

-----------------------------------------------------------
-- Recalculate wrapping when windows are resized
-----------------------------------------------------------

local diagnostic_group = vim.api.nvim_create_augroup("DiagnosticWrapping", { clear = true })

vim.api.nvim_create_autocmd({
	"VimResized",
	"WinResized",
}, {
	group = diagnostic_group,

	callback = function()
		vim.schedule(function()
			local refreshed = {}

			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_is_valid(win) then
					local bufnr = vim.api.nvim_win_get_buf(win)

					if not refreshed[bufnr] and vim.bo[bufnr].buftype == "" then
						refreshed[bufnr] = true
						vim.diagnostic.show(nil, bufnr)
					end
				end
			end
		end)
	end,
})
