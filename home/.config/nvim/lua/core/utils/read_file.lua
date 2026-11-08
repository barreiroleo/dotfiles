---@param path string
---@return string|uv_fs_t
local function read_file_sync(path)
    local fd = assert(vim.uv.fs_open(path, "r", 438))
    local stat = assert(vim.uv.fs_fstat(fd))
    local data = assert(vim.uv.fs_read(fd, stat.size, 0))
    assert(vim.uv.fs_close(fd))
    return data
end

---@param data string|any
---@return string[]
local function parse_content(data)
    if type(data) ~= "string" then
        return {}
    end
    local lines = {}
    for line in data:gmatch("(.-)\n") do
        if line == "" then
            table.insert(lines, "") -- Insert an empty string for empty lines
        else
            table.insert(lines, line)
        end
    end
    return lines
end

---@param path string
---@return string[]
local function read_file_content(path)
    local raw = read_file_sync(path)
    local data = parse_content(raw)
    return data
end

return read_file_content
