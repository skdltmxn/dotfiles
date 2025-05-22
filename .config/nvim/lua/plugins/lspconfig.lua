return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },

		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local ks = vim.keymap.set

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
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

		require("mason").setup()
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
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"eslint_d", -- javascript/typescript formatter
				"pylint", -- python linter
			},
		})
	end,
}
