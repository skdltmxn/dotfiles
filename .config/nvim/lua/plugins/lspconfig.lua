return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"lua_ls",
					"svelte",
					"gopls",
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"eslint_d", -- javascript/typescript formatter
					"pylint", -- python linter
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			local ks = vim.keymap.set
			local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
			local lsp_gc_timeout_ms = tonumber(vim.g.lsp_gc_timeout_ms) or 60000
			local pending_buffer_cleanup = {}

			local function has_managed_lsp_client(bufnr)
				for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
					if vim.lsp.is_enabled(client.name) then
						return true
					end
				end
				return false
			end

			local function stop_orphaned_lsp_clients()
				for _, client in ipairs(vim.lsp.get_clients()) do
					if
						vim.lsp.is_enabled(client.name)
						and client.initialized
						and not client:is_stopped()
						and next(client.attached_buffers) == nil
					then
						-- No document is attached, so force-stop instead of waiting
						-- indefinitely for a language server to exit gracefully.
						client:stop(true)
					end
				end
			end

			local function schedule_buffer_cleanup(bufnr)
				if
					not vim.api.nvim_buf_is_valid(bufnr)
					or vim.bo[bufnr].buftype ~= ""
					or vim.api.nvim_buf_get_name(bufnr) == ""
					or not has_managed_lsp_client(bufnr)
				then
					return
				end

				local cleanup_token = {}
				pending_buffer_cleanup[bufnr] = cleanup_token

				vim.defer_fn(function()
					if pending_buffer_cleanup[bufnr] ~= cleanup_token then
						return
					end
					pending_buffer_cleanup[bufnr] = nil

					if
						not vim.api.nvim_buf_is_valid(bufnr)
						or not vim.api.nvim_buf_is_loaded(bufnr)
						or vim.bo[bufnr].modified
						or #vim.fn.win_findbuf(bufnr) > 0
					then
						return
					end

					-- Keep the buffer in the buffer list so reopening it reloads
					-- the file and lets the enabled LSP config attach again.
					pcall(vim.api.nvim_buf_delete, bufnr, { unload = true })
					vim.schedule(stop_orphaned_lsp_clients)
				end, lsp_gc_timeout_ms)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = lsp_group,
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					ks("n", "[d", vim.diagnostic.goto_prev, opts)
					ks("n", "]d", vim.diagnostic.goto_next, opts)
					ks("n", "gd", vim.lsp.buf.definition, opts)

					ks("n", "<leader>lk", vim.lsp.buf.hover, opts)
					ks("n", "<leader>la", vim.lsp.buf.code_action, opts)
					ks("n", "<leader>li", vim.lsp.buf.implementation, opts)
					ks("n", "<leader>lD", vim.lsp.buf.declaration, opts)
					ks("n", "<leader>lr", vim.lsp.buf.references, opts)
					ks("n", "<leader>lR", vim.lsp.buf.rename, opts)
					ks("n", "<leader>lt", vim.lsp.buf.type_definition, opts)

					-- Root detection can finish after the user has already switched
					-- away from this buffer. Ensure that late clients are collected too.
					if #vim.fn.win_findbuf(ev.buf) == 0 then
						schedule_buffer_cleanup(ev.buf)
					end
				end,
			})

			-- Neovim keeps hidden buffers loaded, so LSP clients from repositories
			-- visited earlier would otherwise remain alive for the whole session.
			-- Unload only unmodified, hidden file buffers after a short grace period.
			vim.api.nvim_create_autocmd("BufHidden", {
				group = lsp_group,
				callback = function(ev)
					schedule_buffer_cleanup(ev.buf)
				end,
			})

			vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete", "BufUnload", "BufWipeout" }, {
				group = lsp_group,
				callback = function(ev)
					pending_buffer_cleanup[ev.buf] = nil
				end,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = lsp_group,
				callback = function()
					-- LspDetach fires before client.attached_buffers is updated.
					vim.schedule(stop_orphaned_lsp_clients)
				end,
			})

			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = "󰌵 ",
						[vim.diagnostic.severity.HINT] = "󰠠 ",
					},
					numhl = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})
		end,
	},
}
