return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	build = "make tiktoken",
	opts = {},
	config = function()
		local chat = require("CopilotChat")
		local ks = vim.keymap.set

		chat.setup()

		ks("n", "<leader>cc", function()
			chat.open()
		end)
	end,
}
