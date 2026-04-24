return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "bash",
                "javascript",
                "typescript",
                "go",
                "lua",
                "rust",
                "svelte",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(ev.match)
                    if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then
                        return
                    end
                    if vim.treesitter.query.get(lang, "indents") then
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })

            -- incremental selection via built-in treesitter node text objects
            -- note: <bs> selects inner node at cursor, not a true "shrink one level"
            vim.keymap.set("n", "<C-space>", "van", { desc = "Select treesitter node" })
            vim.keymap.set("x", "<C-space>", "an", { desc = "Expand to parent node" })
            vim.keymap.set("x", "<bs>", "in", { desc = "Select inner node" })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = false,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move = { set_jumps = true },
            })

            local sel = require("nvim-treesitter-textobjects.select")
            local mov = require("nvim-treesitter-textobjects.move")
            local swp = require("nvim-treesitter-textobjects.swap")

            local select_maps = {
                { "aa", "@parameter.outer", "Around parameter" },
                { "ia", "@parameter.inner", "Inside parameter" },
                { "af", "@function.outer",  "Around function" },
                { "if", "@function.inner",  "Inside function" },
                { "ac", "@class.outer",     "Around class" },
                { "ic", "@class.inner",     "Inside class" },
            }
            for _, m in ipairs(select_maps) do
                vim.keymap.set({ "x", "o" }, m[1], function()
                    sel.select_textobject(m[2], "textobjects")
                end, { desc = m[3] })
            end

            local move_maps = {
                { "]m",  "goto_next_start",     "@function.outer", "Next function start" },
                { "]]",  "goto_next_start",     "@class.outer",    "Next class start" },
                { "]M",  "goto_next_end",       "@function.outer", "Next function end" },
                { "][",  "goto_next_end",       "@class.outer",    "Next class end" },
                { "[m",  "goto_previous_start", "@function.outer", "Prev function start" },
                { "[[",  "goto_previous_start", "@class.outer",    "Prev class start" },
                { "[M",  "goto_previous_end",   "@function.outer", "Prev function end" },
                { "[]",  "goto_previous_end",   "@class.outer",    "Prev class end" },
            }
            for _, m in ipairs(move_maps) do
                vim.keymap.set({ "n", "x", "o" }, m[1], function()
                    mov[m[2]](m[3], "textobjects")
                end, { desc = m[4] })
            end

            vim.keymap.set("n", "<leader>a", function()
                swp.swap_next("@parameter.inner", "textobjects")
            end, { desc = "Swap next parameter" })
            vim.keymap.set("n", "<leader>A", function()
                swp.swap_previous("@parameter.inner", "textobjects")
            end, { desc = "Swap previous parameter" })
        end,
    },
}
