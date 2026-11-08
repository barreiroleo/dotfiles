return {
    "ThePrimeagen/99",
    opts = {
        md_files = {
            "AGENT.md",
        },
        -- opencode models --refresh | grep opencode
        -- model = "github-copilot/gpt-5.1-codex-mini",
        model = "opencode-go/deepseek-v4-flash" -- opencode/big-pickle
    },

    keys = {
        { mode = "v",          "<leader>9v", function() require("99").visual({}) end,          desc = "Visual select and send to 99" },
        { mode = { "n", "v" }, "<leader>9s", function() require("99").stop_all_requests() end, desc = "Stop all 99 requests" },
    },

}
