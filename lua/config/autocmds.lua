local group = vim.api.nvim_create_augroup("BaseNvim", {
	clear = true,
})

-- Refresh files changed outside Neovim.
vim.api.nvim_create_autocmd({
	"FocusGained",
	"BufEnter",
	"CursorHold",
}, {
	group = group,
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight copied text.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank({ timeout = 170 })
	end,
})

-- Go indentation.
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = {
		"go",
		"gomod",
		"gowork",
		"make",
	},
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

-- Text and Markdown settings.
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = {
		"markdown",
		"gitcommit",
		"text",
	},
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- Remove unused TypeScript / JavaScript imports.
local function remove_unused_imports(bufnr)
	if not vim.bo[bufnr].modifiable then
		return
	end

	local clients = vim.lsp.get_clients({
		bufnr = bufnr,
		name = "vtsls",
	})

	local client = clients[1]

	if not client then
		return
	end

	if not client:supports_method("textDocument/codeAction") then
		return
	end

	local timeout = 2000

	local params = {
		textDocument = vim.lsp.util.make_text_document_params(bufnr),
		range = {
			start = { line = 0, character = 0 },
			["end"] = { line = 0, character = 0 },
		},
		context = {
			diagnostics = {},
			only = {
				"source.removeUnusedImports",
			},
		},
	}

	-- Synchronous request ensures changes happen before saving.
	local response = client:request_sync("textDocument/codeAction", params, timeout, bufnr)

	if not response or not response.result then
		return
	end

	for _, action in ipairs(response.result) do
		if action.kind == "source.removeUnusedImports" then
			-- Resolve actions that don't contain edits yet.
			if not action.edit and not action.command and client:supports_method("codeAction/resolve") then
				local resolved = client:request_sync("codeAction/resolve", action, timeout, bufnr)

				if resolved and resolved.result then
					action = resolved.result
				end
			end

			-- Apply direct workspace edits.
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
			end

			-- Execute server-side commands when necessary.
			if action.command then
				local command = action.command

				if type(command) == "string" then
					command = {
						command = command,
						arguments = action.arguments,
					}
				end

				client:request_sync("workspace/executeCommand", command, timeout, bufnr)
			end
		end
	end
end

-- Automatically clean imports before writing the file.
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = {
		"*.ts",
		"*.tsx",
		"*.mts",
		"*.cts",
		"*.js",
		"*.jsx",
		"*.mjs",
		"*.cjs",
	},
	callback = function(args)
		remove_unused_imports(args.buf)
	end,
	desc = "Remove unused TypeScript/JavaScript imports on save",
})
