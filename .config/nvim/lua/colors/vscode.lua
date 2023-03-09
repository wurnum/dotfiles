local c = require('vscode.colors').get_colors()

require('vscode').setup({
    -- Enable transparent background
    disable_nvimtree_bg = true,

    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})

