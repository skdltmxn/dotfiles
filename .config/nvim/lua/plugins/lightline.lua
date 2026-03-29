return {
    {
        "catppuccin/vim",
        name = "catppuccin-vim",
        lazy = false,
    },
    {
        "itchyny/lightline.vim",
        config = function()
            vim.g.lightline = {
                colorscheme = "catppuccin_frappe",
                active = {
                    left = { { "mode", "paste" }, { "readonly", "absolutepath", "modified" } },
                }
            }
        end
    },
}
