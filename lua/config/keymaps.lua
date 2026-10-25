local map = vim.keymap.set

-- Files and search
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", {
	desc = "Toggle file explorer",
})

map("n", "<leader>f", "<cmd>Telescope find_files<CR>", {
	desc = "Find files",
})

map("n", "<leader>s", "<cmd>Telescope live_grep<CR>", {
	desc = "Search project text",
})

map("n", "<leader>b", "<cmd>Telescope buffers<CR>", {
	desc = "Find open buffers",
})

map("n", "<leader>o", "<cmd>Telescope oldfiles<CR>", {
	desc = "Recently opened files",
})

-- Editing and buffers
map("n", "<leader>w", "<cmd>write<CR>", {
	desc = "Save file",
})

map("n", "<leader>q", "<cmd>quit<CR>", {
	desc = "Close window",
})

map("n", "<S-h>", "<cmd>bprevious<CR>", {
	desc = "Previous buffer",
})

map("n", "<S-l>", "<cmd>bnext<CR>", {
	desc = "Next buffer",
})

map({ "n", "v" }, "<leader>F", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, {
	desc = "Format buffer or selection",
})

-- LSP
map("n", "gd", vim.lsp.buf.definition, {
	desc = "Go to definition",
})

map("n", "gr", vim.lsp.buf.references, {
	desc = "Find references",
})

map("n", "gi", vim.lsp.buf.implementation, {
	desc = "Go to implementation",
})

map("n", "K", vim.lsp.buf.hover, {
	desc = "Show documentation",
})

map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, {
	desc = "Code action",
})

map("n", "<leader>r", vim.lsp.buf.rename, {
	desc = "Rename symbol",
})

-- Diagnostics
map("n", "<leader>d", "<cmd>Trouble diagnostics toggle<CR>", {
	desc = "Project diagnostics",
})

map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, {
	desc = "Next diagnostic",
})

map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, {
	desc = "Previous diagnostic",
})

-- Git
map("n", "<C-S-g>", "<cmd>Neogit<CR>", {
	desc = "Open Git central",
})

map("n", "<leader>gg", "<cmd>Neogit<CR>", {
	desc = "Open Git central",
})

map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", {
	desc = "View Git diff",
})

map("n", "<leader>gc", "<cmd>DiffviewClose<CR>", {
	desc = "Close Git diff",
})

-- Window navigation
local focus = {
	h = "left",
	j = "below",
	k = "above",
	l = "right",
}

for direction, label in pairs(focus) do
	map("n", "<C-" .. direction .. ">", "<C-w>" .. direction, {
		desc = "Focus window " .. label,
	})

	-- Preserve Ctrl+L for clearing the terminal.
	if direction ~= "l" then
		map("t", "<C-" .. direction .. ">", "<C-\\><C-n><C-w>" .. direction, {
			desc = "Focus window " .. label .. " from terminal",
		})
	end
end

-- Buffer navigation
-- Tab cycles through open files, not split windows.
map("n", "<Tab>", "<cmd>bnext<CR>", {
	desc = "Next open file",
})

map("n", "<S-Tab>", "<cmd>bprevious<CR>", {
	desc = "Previous open file",
})

-- Terminal
local terminal_buffer = nil

local function toggle_terminal()
	-- Hide terminal if already visible.
	if terminal_buffer and vim.api.nvim_buf_is_valid(terminal_buffer) then
		for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.api.nvim_win_get_buf(window) == terminal_buffer then
				vim.api.nvim_win_close(window, false)
				return
			end
		end
	end

	-- Open terminal at bottom, 12 lines tall.
	vim.cmd("botright 12split")

	-- Reuse existing running terminal.
	local job = terminal_buffer
		and vim.api.nvim_buf_is_valid(terminal_buffer)
		and vim.b[terminal_buffer].terminal_job_id

	local running = type(job) == "number" and vim.fn.jobwait({ job }, 0)[1] == -1

	if running then
		vim.api.nvim_win_set_buf(0, terminal_buffer)
	else
		vim.cmd("terminal")
		terminal_buffer = vim.api.nvim_get_current_buf()
		vim.bo[terminal_buffer].bufhidden = "hide"
	end

	-- Enter terminal input mode.
	vim.cmd("startinsert")
end

-- Toggle bottom terminal
map("n", "<leader>h", toggle_terminal, {
	desc = "Toggle bottom terminal",
})

map("n", "<leader>H", toggle_terminal, {
	desc = "Toggle bottom terminal",
})

-- Ctrl+X exits terminal input mode.
map("t", "<C-x>", "<C-\\><C-n>", {
	desc = "Exit terminal input mode",
})
