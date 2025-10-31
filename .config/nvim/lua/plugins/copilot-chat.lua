return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		build = "make tiktoken",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			{ "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
		},
		opts = {
			window = {
				layout = "float",
				width = 0.6,
				height = 50,
				zindex = 100,
			},
			auto_insert_mode = true,
			auto_fold = true,
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")
			-- Use unnamed register for the selection
			opts.selection = select.unnamed

			chat.setup(opts)
		end,
		event = "VeryLazy",
		keys = {
			-- Show prompts actions with telescope
			{ "<leader>ccp", "<cmd>CopilotChatOpen<cr>", desc = "CopilotChat - Prompt actions" },
			{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>ccn", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
			{ "<leader>ccm", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Better Naming" },
			-- Custom input for CopilotChat
			{
				"<leader>cci",
				function()
					local input = vim.fn.input("Ask Copilot: ")
					if input ~= "" then
						vim.cmd("CopilotChat " .. input)
					end
				end,
				desc = "CopilotChat - Ask input",
			},
			-- Quick chat with Copilot
			{
				"<leader>ccq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			-- Clear buffer and chat history
			{
				"<leader>ccl",
				"<cmd>CopilotChatReset<cr>",
				desc = "CopilotChat - Clear buffer and chat history",
			},
		},
	},
}
