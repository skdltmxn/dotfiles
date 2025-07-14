return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local format_setting = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 500,
		}

		conform.setup({
			format_on_save = format_setting,
		})

		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			conform.format(format_setting)
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
