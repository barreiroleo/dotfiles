local M = {}

function M.cmd_backsearch (file, line, col)
    local drop_cmd = string.format(":lua require('%s').drop_tex('%s', %s, %s)<CR>", "core.lsp.handlers.texlab_cmd", file, line, col or 0)
    local cmd = string.format("\"nvim --server %s --remote-send \\%q\\\"", "/tmp/nvim.latex", drop_cmd) -- vim.v.servername
    return cmd
end

-- Launch vim at position listen at server:
-- nvim --listen /tmp/nvim.latex src/main.tex -c ":call cursor(29,8)"
function M.drop_tex(file, line, col)
    file, line, col = vim.fs.normalize(file), line or 0, col or 0
    -- HACK: There's an issue with sioyek. Remove it when will fixed.
    file = string.gsub(file, "/./", "/")
    file = string.gsub(file, " ", "\\ ")
    vim.cmd(string.format(":drop %s|call cursor(%s, %s)", file, line, col))
end

-- -- TEST: Build backsearch command
-- M.cmd_backsearch("%1", "%2", "%3")

-- -- TEST: Drop text
-- local args = {
--     file = "~/develop/proyects/pps/src/./ch-02/Actividades.tex",
--     pos = {16, 10}
-- }
-- M.drop_tex(args.file, args.pos[1], args.pos[2])

return M
