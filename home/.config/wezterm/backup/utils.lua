local wezterm = require("wezterm")

local M = {}

---@return table
---@param a table
---@param b table
function M:merge_tables(a, b)
    for k, v in pairs(b) do
        a[k] = v
    end
    return a
end

---@class GPU_Spec
---@field webgpu_power_performance string
---@field front_end string
---@return GPU_Spec
function M:use_interated_gpu()
    local _config = { webgpu_preferred_adapter = "LowPower", front_end = "WebGpu" }
    for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
        if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" then
            _config = {
                webgpu_preferred_adapter = gpu,
                front_end = "WebGpu",
            }
            break
        end
    end
    return _config
end

return M
