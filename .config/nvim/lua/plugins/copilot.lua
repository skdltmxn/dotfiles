return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")

        require("copilot").setup({
            copilot_model = "GPT-5",
            panel = { enabled = false },
            suggestion = {
                auto_trigger = true,
                trigger_on_accept = false,
                keymap = { accept = false }, -- will be configured in nvim-cmp
            }
        })

        cmp.event:on("menu_opened", function()
            vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
            vim.b.copilot_suggestion_hidden = false
        end)
    end,
}
