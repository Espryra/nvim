-- Custom Neovim commands

vim.api.nvim_create_user_command("ConfigEdit", function()
	vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, {
	desc = "Edit Neovim configuration",
})

vim.api.nvim_create_user_command("LspStatus", function()
	vim.cmd("checkhealth vim.lsp")
end, {
	desc = "Show LSP health",
})

-- Create an unlisted temporary buffer.
-- It will not appear in Bufferline.
local function create_empty_buffer()
	local bufnr = vim.api.nvim_create_buf(false, true)

	-- Automatically destroy it when no longer displayed.
	vim.bo[bufnr].bufhidden = "wipe"

	return bufnr
end

-- Identify unused, empty, unnamed buffers.
local function is_unused_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end

	if not vim.bo[bufnr].buflisted then
		return false
	end

	if vim.bo[bufnr].buftype ~= "" then
		return false
	end

	if vim.bo[bufnr].modified then
		return false
	end

	if vim.api.nvim_buf_get_name(bufnr) ~= "" then
		return false
	end

	-- Never remove a buffer containing text.
	if vim.api.nvim_buf_line_count(bufnr) ~= 1 then
		return false
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)

	if lines[1] ~= "" then
		return false
	end

	-- Never remove buffers visible in any window.
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			if vim.api.nvim_win_get_buf(win) == bufnr then
				return false
			end
		end
	end

	return true
end

-- Clean up abandoned empty buffers when opening real files.
local cleanup_group = vim.api.nvim_create_augroup("CleanupUnnamedBuffers", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = cleanup_group,

	callback = function(args)
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		vim.schedule(function()
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if is_unused_buffer(bufnr) then
					vim.api.nvim_buf_delete(bufnr, {
						force = false,
					})
				end
			end
		end)
	end,
})

-- Close only the current file, keeping Neovim open.
local function close_file(force)
	local bufnr = vim.api.nvim_get_current_buf()

	-- Handle special buffers like terminals and Neo-tree.
	if vim.bo[bufnr].buftype ~= "" then
		local windows = vim.api.nvim_tabpage_list_wins(0)

		if #windows > 1 then
			vim.cmd(force and "close!" or "close")
		else
			vim.api.nvim_win_set_buf(0, create_empty_buffer())
		end

		return
	end

	-- Protect unsaved changes.
	if vim.bo[bufnr].modified and not force then
		vim.notify("Unsaved changes. Use :w or :q!", vim.log.levels.WARN)
		return
	end

	-- Find another open file to display.
	local replacement = nil
	local alternate = vim.fn.bufnr("#")

	local function is_file_buffer(buf)
		return buf ~= bufnr
			and vim.api.nvim_buf_is_valid(buf)
			and vim.bo[buf].buflisted
			and vim.bo[buf].buftype == ""
			and vim.api.nvim_buf_get_name(buf) ~= ""
	end

	-- Prefer the previously active file.
	if alternate > 0 and is_file_buffer(alternate) then
		replacement = alternate
	end

	-- Otherwise find any other listed file.
	if not replacement then
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if is_file_buffer(buf) then
				replacement = buf
				break
			end
		end
	end

	-- No other files: use an unlisted temporary buffer.
	if not replacement then
		replacement = create_empty_buffer()
	end

	-- Replace the file in every window displaying it.
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			if vim.api.nvim_win_get_buf(win) == bufnr then
				vim.api.nvim_win_set_buf(win, replacement)
			end
		end
	end

	-- Delete the original file buffer.
	vim.api.nvim_buf_delete(bufnr, {
		force = force,
	})
end

-- Explicit close-file command.
vim.api.nvim_create_user_command("CloseFile", function(args)
	close_file(args.bang)
end, {
	bang = true,
	desc = "Close current file without exiting Neovim",
})

-- Make :q close the current file.
-- Leave :qa and :qa! unchanged.
vim.cmd([[
  cnoreabbrev <expr> q (getcmdtype() == ':' && getcmdline() ==# 'q') ? 'CloseFile' : 'q'
]])

-- Custom Neovim commands

vim.api.nvim_create_user_command("ConfigEdit", function()
	vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, {
	desc = "Edit Neovim configuration",
})

vim.api.nvim_create_user_command("LspStatus", function()
	vim.cmd("checkhealth vim.lsp")
end, {
	desc = "Show LSP health",
})

-- Create an unlisted temporary buffer.
-- It will not appear in Bufferline.
local function create_empty_buffer()
	local bufnr = vim.api.nvim_create_buf(false, true)

	-- Automatically destroy it when no longer displayed.
	vim.bo[bufnr].bufhidden = "wipe"

	return bufnr
end

-- Identify unused, empty, unnamed buffers.
local function is_unused_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end

	if not vim.bo[bufnr].buflisted then
		return false
	end

	if vim.bo[bufnr].buftype ~= "" then
		return false
	end

	if vim.bo[bufnr].modified then
		return false
	end

	if vim.api.nvim_buf_get_name(bufnr) ~= "" then
		return false
	end

	-- Never remove a buffer containing text.
	if vim.api.nvim_buf_line_count(bufnr) ~= 1 then
		return false
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)

	if lines[1] ~= "" then
		return false
	end

	-- Never remove buffers visible in any window.
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			if vim.api.nvim_win_get_buf(win) == bufnr then
				return false
			end
		end
	end

	return true
end

-- Clean up abandoned empty buffers when opening real files.
local cleanup_group = vim.api.nvim_create_augroup("CleanupUnnamedBuffers", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
	group = cleanup_group,

	callback = function(args)
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		vim.schedule(function()
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if is_unused_buffer(bufnr) then
					vim.api.nvim_buf_delete(bufnr, {
						force = false,
					})
				end
			end
		end)
	end,
})

-- Close only the current file, keeping Neovim open.
local function close_file(force)
	local bufnr = vim.api.nvim_get_current_buf()

	-- Handle special buffers like terminals and Neo-tree.
	if vim.bo[bufnr].buftype ~= "" then
		local windows = vim.api.nvim_tabpage_list_wins(0)

		if #windows > 1 then
			vim.cmd(force and "close!" or "close")
		else
			vim.api.nvim_win_set_buf(0, create_empty_buffer())
		end

		return
	end

	-- Protect unsaved changes.
	if vim.bo[bufnr].modified and not force then
		vim.notify("Unsaved changes. Use :w or :q!", vim.log.levels.WARN)
		return
	end

	-- Find another open file to display.
	local replacement = nil
	local alternate = vim.fn.bufnr("#")

	local function is_file_buffer(buf)
		return buf ~= bufnr
			and vim.api.nvim_buf_is_valid(buf)
			and vim.bo[buf].buflisted
			and vim.bo[buf].buftype == ""
			and vim.api.nvim_buf_get_name(buf) ~= ""
	end

	-- Prefer the previously active file.
	if alternate > 0 and is_file_buffer(alternate) then
		replacement = alternate
	end

	-- Otherwise find any other listed file.
	if not replacement then
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if is_file_buffer(buf) then
				replacement = buf
				break
			end
		end
	end

	-- No other files: use an unlisted temporary buffer.
	if not replacement then
		replacement = create_empty_buffer()
	end

	-- Replace the file in every window displaying it.
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			if vim.api.nvim_win_get_buf(win) == bufnr then
				vim.api.nvim_win_set_buf(win, replacement)
			end
		end
	end

	-- Delete the original file buffer.
	vim.api.nvim_buf_delete(bufnr, {
		force = force,
	})
end

-- Explicit close-file command.
vim.api.nvim_create_user_command("CloseFile", function(args)
	close_file(args.bang)
end, {
	bang = true,
	desc = "Close current file without exiting Neovim",
})

-- Make :q close the current file.
-- Leave :qa and :qa! unchanged.
vim.cmd([[
  cnoreabbrev <expr> q (getcmdtype() == ':' && getcmdline() ==# 'q') ? 'CloseFile' : 'q'
]])
