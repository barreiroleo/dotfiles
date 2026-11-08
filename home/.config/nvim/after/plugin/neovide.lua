if vim.g.neovide then
    -- vim.opt.guifont = { "Hack NF", ":h10"}
    vim.g.neovide_transparency      = 0.9
    vim.g.neovide_cursor_trail_size = 0.01

    vim.g.gui_font_default_size = 12
    vim.g.gui_font_size = vim.g.gui_font_default_size
    vim.g.gui_font_face = "UbuntuMono Nerd Font"

    RefreshGuiFont = function()
        -- vim.opt.guifont = { "UbuntuMono Nerd Font", ":h12" }
        vim.opt.guifont = string.format("%s:h%s",vim.g.gui_font_face, vim.g.gui_font_size)
    end

    ResizeGuiFont = function(delta)
        vim.g.gui_font_size = vim.g.gui_font_size + delta
        RefreshGuiFont()
    end

    ResetGuiFont = function()
        vim.g.gui_font_size = vim.g.gui_font_default_size
        RefreshGuiFont()
    end

    -- Call function on startup to set default value
    ResetGuiFont()

    -- Keymaps

    local opts = { noremap = true, silent = true }

    vim.keymap.set({'n', 'i'}, "<C-+>", function() ResizeGuiFont(1)  end, opts)
    vim.keymap.set({'n', 'i'}, "<C-->", function() ResizeGuiFont(-1) end, opts)
end
