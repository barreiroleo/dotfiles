-- Credits to: https://github.com/juniorsundar/nvim/blob/main/lua/config/lsp/breadcrumbs.lua

vim.lsp.breadcrumbs = {
    enabled = true,
}
local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

local folder_icon = "%#Conditional#" .. "󰉋" .. "%#Normal#"
local file_icon = "󰈙"

local kind_icons = {
    [1] = "%#File#" .. "󰈙" .. "%#Normal#", -- file
    [2] = "%#Module#" .. "󰠱" .. "%#Normal#", -- module
    [3] = "%#Structure#" .. "" .. "%#Normal#", -- namespace
    [19] = "%#Keyword#" .. "󰌋" .. "%#Normal#", -- key
    [5] = "%#Class#" .. "" .. "%#Normal#", -- class
    [6] = "%#Method#" .. "󰆧" .. "%#Normal#", -- method
    [7] = "%#Property#" .. "" .. "%#Normal#", -- property
    [8] = "%#Field#" .. "" .. "%#Normal#", -- field
    [9] = "%#Function#" .. "" .. "%#Normal#", -- constructor
    [10] = "%#Enum#" .. "" .. "%#Normal#", -- enum
    [11] = "%#Type#" .. "" .. "%#Normal#", -- interface
    [12] = "%#Function#" .. "󰊕" .. "%#Normal#", -- function
    [13] = "%#None#" .. "󰂡" .. "%#Normal#", -- variable
    [14] = "%#Constant#" .. "󰏿" .. "%#Normal#", -- constant
    [15] = "%#String#" .. "" .. "%#Normal#", -- string
    [16] = "%#Number#" .. "" .. "%#Normal#", -- number
    [17] = "%#Boolean#" .. "" .. "%#Normal#", -- boolean
    [18] = "%#Array#" .. "" .. "%#Normal#", -- array
    [20] = "%#Class#" .. "" .. "%#Normal#", -- object
    [4] = "", -- package
    [21] = "󰟢", -- null
    [22] = "", -- enum-member
    [23] = "%#Struct#" .. "" .. "%#Normal#", -- struct
    [24] = "", -- event
    [25] = "", -- operator
    [26] = "󰅲", -- type-parameter
}

local function range_contains_pos(range, line, char)
    local start = range.start
    local stop = range['end']

    if line < start.line or line > stop.line then
        return false
    end

    if line == start.line and char < start.character then
        return false
    end

    if line == stop.line and char > stop.character then
        return false
    end

    return true
end

local function find_symbol_path(symbol_list, line, char, path)
    if not symbol_list or #symbol_list == 0 then
        return false
    end

    for _, symbol in ipairs(symbol_list) do
        if symbol.range and range_contains_pos(symbol.range, line, char) then
            local icon = kind_icons[symbol.kind] or ""
            table.insert(path, icon .. " " .. symbol.name)
            find_symbol_path(symbol.children, line, char, path)
            return true
        end
    end
    return false
end

local function lsp_callback(err, symbols, ctx, config)
    if err or not symbols then
        vim.o.winbar = ""
        return
    end

    local winnr = vim.api.nvim_get_current_win()
    local pos = vim.api.nvim_win_get_cursor(0)
    local cursor_line = pos[1] - 1
    local cursor_char = pos[2]

    local file_path = vim.fn.bufname(ctx.bufnr)
    if not file_path or file_path == "" then
        vim.o.winbar = "[No Name]"
        return
    end

    local relative_path

    local clients = vim.lsp.get_clients({ bufnr = ctx.bufnr })

    if #clients > 0 and clients[1].root_dir then
        local root_dir = clients[1].root_dir
        if root_dir == nil then
            relative_path = file_path
        else
            relative_path = vim.fs.relpath(root_dir, file_path)
        end
    else
        local root_dir = vim.fn.getcwd(0)
        relative_path = vim.fs.relpath(root_dir, file_path)
    end

    if not relative_path then
        relative_path = file_path
    end

    local breadcrumbs = {}

    local path_components = vim.split(relative_path, "[/\\]", { trimempty = true })
    local num_components = #path_components

    for i, component in ipairs(path_components) do
        if i == num_components then
            local icon, icon_hl = file_icon, ""

            if devicons_ok then
                icon, icon_hl = devicons.get_icon(component)
            end
            table.insert(breadcrumbs, "%#" .. icon_hl .. "#" .. icon .. "%#Normal#" .. " " .. component)
        else
            table.insert(breadcrumbs, folder_icon .. " " .. component)
        end
    end
    find_symbol_path(symbols, cursor_line, cursor_char, breadcrumbs)

    local breadcrumb_string = table.concat(breadcrumbs, " > ")

    if breadcrumb_string ~= "" then
        vim.api.nvim_set_option_value('winbar', breadcrumb_string, { win = winnr })
    else
        vim.api.nvim_set_option_value('winbar', " ", { win = winnr })
    end
end

local function breadcrumbs_set()
    if not vim.lsp.breadcrumbs.enabled then
        return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_buf()

    local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentSymbol" })
    if #clients == 0 then
        return
    end

    local uri = vim.lsp.util.make_text_document_params(bufnr)["uri"]
    if not uri then
        vim.print("Error: Could not get URI for buffer. Is it saved?")
        return
    end

    local buf_src = uri:sub(1, uri:find(":") - 1)
    if buf_src ~= "file" then
        vim.o.winbar = ""
        return
    end

    local params = { textDocument = { uri = uri, }, }
    vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, lsp_callback)
end

local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd({ "CursorHold" }, {
    group = breadcrumbs_augroup,
    callback = breadcrumbs_set,
    desc = "Set breadcrumbs.",
})

-- vim.api.nvim_create_autocmd({ "WinLeave" }, {
--     group = breadcrumbs_augroup,
--     callback = function()
--         vim.o.winbar = ""
--     end,
--     desc = "Clear breadcrumbs when leaving window.",
-- })

local function toggle_breadcrumbs()
    if vim.lsp.breadcrumbs == nil then
        vim.notify("`vim.lsp.breadcrumbs` doesn't exists!", vim.log.levels.WARN, { title = "LSP" })
        return
    end
    if vim.lsp.breadcrumbs.enabled == nil then
        vim.notify("`vim.lsp.breadcrumbs.enabled` doesn't exists!", vim.log.levels.WARN, { title = "LSP" })
        return
    end
    vim.lsp.breadcrumbs.enabled = not vim.lsp.breadcrumbs.enabled
    if vim.lsp.breadcrumbs.enabled then
        vim.notify("Auto Hover enabled", vim.log.levels.INFO, { title = "LSP" })
    else
        vim.notify("Auto Hover disabled", vim.log.levels.INFO, { title = "LSP" })
        vim.o.winbar = ""
    end
end

vim.keymap.set("n", "<leader><leader>TB", toggle_breadcrumbs,
    { desc = "Toggle LSP breadcrumbs", noremap = false, silent = true }
)
