---@alias LspProgress.EventData {client_id: integer, params: lsp.ProgressParams}
---
---Built-in vim data type. Received from autocmd's event-data.data.params.value
---Example of progress messages:
---  { kind = "report", message = "79/244", percentage = 31, title = "Loading workspace" }
---  { cancellable = false, kind = "begin", message = "71/244", percentage = 29, title = "Loading workspace" }
---@class LspProgress.EventData.Params.Value
---@field title string? Title of the progress
---@field kind "begin" | "report" | "end"?
---@field percentage number? Progress percentage (0-100)
---@field message string? Message for the progress
---
---@class LspProgress.Message: LspProgress.EventData.Params.Value
---@field title string Override title of the progress with the client name
---@field spinner string
---
---@alias LspProgress.Status
---| 0 # "Loading"
---| 1 # "Done"
---| 2 # "Error"
---
---@class LspProgress.Client
---@field client_id integer Identifier for the LSP client
---@field client_name string Name of the LSP client
---@field attached_buffers integer[] List of buffer numbers attached to this client
---@field last_msg LspProgress.Message? Last messange received from the server

---@type {[integer]: LspProgress.Client} Dictionary mapping client IDs to LSP clients
local _clients = {}

---@type string[]
local SPINNER = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

---@param client_id integer
---@param value LspProgress.EventData.Params.Value
local function update_progress_cache(client_id, value)
    local client = _clients[client_id] or {}
    local last_percentage = client.last_msg and client.last_msg.percentage
    local new_percentage = (value.kind == "end" and 100) or (value.percentage) or (0)

    if last_percentage == new_percentage then
        return
    end

    _clients[client_id].last_msg = {
        title = client.client_name,
        percentage = new_percentage,
        message = string.format("[%3d%%] %s %s", new_percentage, value.title, value.message or ""),
        spinner = (new_percentage == 100 and "✓") or (SPINNER[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #SPINNER + 1]),
    }

    -- Clear the message after 500ms the progress finished
    vim.defer_fn(function()
        if last_percentage == 100 then _clients[client_id].last_msg = nil end
    end, 500)
end

---
--- PUBLIC API
---
local M = { _loaded = false }

---@param event_data {data: LspProgress.EventData}
---@return LspProgress.Message?
function M.get_last_msg_for_client(event_data)
    M.setup()
    return _clients[event_data.data.client_id].last_msg
end

---Loading => "[[ ⠏ client: 27%; ...]]"
---Done    => "[[ client ; ...]]"
---@return string Formatted string for statusline
function M.get_statusline_data()
    M.setup()
    local current_buf = vim.api.nvim_get_current_buf()

    local clients = vim.iter(_clients):fold({}, function(acc, client)
        local is_attached = vim.iter(client.attached_buffers):any(
            function(v) return v == current_buf end
        )
        if not is_attached then return acc end

        -- Insert ready clients
        if not client.last_msg then
            table.insert(acc, client.client_name)
            return acc
        end

        -- Insert clients in progress
        local percentage = (client.last_msg.percentage == 100 and "") or (": " .. client.last_msg.percentage .. "%%")
        local spinner = (client.last_msg.percentage == 100 and "") or (client.last_msg.spinner .. " ")
        table.insert(acc, string.format("%s%s%s", spinner, client.last_msg.title, percentage))

        return acc
    end)

    return "[ " .. table.concat(clients, ", ") .. " ]"
end

function M.setup()
    if M._loaded then return end

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event_data)
            local client = vim.lsp.get_client_by_id(event_data.data.client_id)
            if not client then return end

            local attached_buffs = _clients[client.id] and _clients[client.id].attached_buffers or {}
            attached_buffs[#attached_buffs + 1] = event_data.buf

            _clients[client.id] = {
                client_id = client.id,
                client_name = client.name,
                attached_buffers = attached_buffs,
            }
        end,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
        callback = function(event_data)
            local client_id = event_data.data.client_id
            if not _clients[client_id] then return end

            _clients[client_id].attached_buffers = vim.iter(_clients[client_id].attached_buffers):filter(function(v)
                return v ~= event_data.data.buf
            end):totable()
        end,
    })

    vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(event_data)
            local client = vim.lsp.get_client_by_id(event_data.data.client_id)
            if not client then return end

            vim.schedule(function()
                update_progress_cache(client.id,
                    event_data.data.params.value --[[@as LspProgress.EventData.Params.Value]])
            end)
        end,
    })

    M._loaded = true
end

function M.inspect()
    vim.notify(string.format("LSP map: %s", vim.inspect(_clients)))
end

return M
