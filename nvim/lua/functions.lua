-- Helper functions for Neovim
-- Sourced from init.vim.

-- Function to enable/disable diagnostics.
vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
        vim.g.diagnostics_visible = false
        vim.diagnostic.disable()
        print('Disabled diagnostics.')
    else
        vim.g.diagnostics_visible = true
        vim.diagnostic.enable()
        print('Enabled diagnostics.')
    end
end
