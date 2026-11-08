--[[

| Model Name            | Cutoff    | C++23 | Speed          | Other Notes                                            | CodeCompanion bugs          |
|-----------------------|-----------|-------|----------------| -------------------------------------------------------|-----------------------------|
| deepseek-r1:14b       | ?         | Yes   | Fast preocess  | Reasoning verbosity makes responses too long and slow. |                             |
| deepseek-coder-v2     | ?         | C++20 | Fast           | Horrible in general adn at C++.                        | Horrible at inline          |
| codegemma:7b-instruct | ?         | Yes   | Fast           |                                                        | Horrible in general         |
| mistral-small:22b     | 2023 Oct. | Yes   | Slow / precise | Tends to cite bibliography.                            |                             |
| mistral-nemo:12b      | 2021?     | Draft | Fast           | Tends to hallucinate. Still better than mistral:7b     |                             |
| codestral:22b         | 2021      | No    | Slow           |                                                        |                             |
| => qwen3:8b           | 2024 Oct. | Yes   | Fast / precise | Tends to verbosity.                                    |                             |
| exaone-deep:7.8b      | 2024 Abr. | Yes   | Fast / precise | Tends to concise. I prefeer qwen3.                     |                             |
| gemma3:12b            | 2024 Mar. | Yes   | Slow (super)   | Good as code reviewer/summaries. Similar to phi4.      | Format output breaks inline |
| => phi4:14b           | 2023 Oct. | Yes   | Fast / quality |                                                        |                             |
| cogito:14b            | 2023 Apr. | Yes   | Fast / quality | Feels good. Need to compare whit phi4                  |                             |

--]]

local phi4 = function()
    return require("codecompanion.adapters").extend("ollama", {
        name = "phi4",
        schema = {
            model = {
                default = "phi4:14b"
            },
        },
    })
end

local gemma3 = function()
    return require("codecompanion.adapters").extend("ollama", {
        name = "gemma3",
        schema = {
            model = {
                default = "gemma3:12b",
            },
            temperature = { default = 1.0 },
            top_k = { default = 64 },
            top_p = { default = 0.95 },
        },
    })
end

local qwen3 = function()
    return require("codecompanion.adapters").extend("ollama", {
        name = "qwen3",
        schema = {
            model = {
                default = "qwen3:8b"
            },
        },
    })
end

local commit_prompt =
[[
You are a senior software engineer. Given this diff, generate a commit message filling the %placeholder% in the template:
Use "N/A" when a certain tag doesn't apply. Do not hallucinate.
```
%Conventional commit title%

[DESCRIPTION]:
%Description%
[WHY]:
%Why%
[ISSUE]:
%Issue%
```
]]

return {
    "olimorris/codecompanion.nvim",
    enabled = false,
    event = { 'BufNewFile', 'BufReadPre' },
    cmd = {
        "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        strategies = {
            -- For local use: agent=phi4, chat=gemma3/qwen3, inline=phi4
            agent = { adapter = { name = "copilot", model = "claude-sonnet-4" } },
            chat = { adapter = { name = "copilot", model = "claude-sonnet-4" } },
            inline = { adapter = { name = "copilot", model = "claude-sonnet-4" } },
        },
        adapters = {
            http = {
                phi4 = phi4,
                gemma3 = gemma3,
                qwen3 = qwen3,
            }
        },

        prompt_library = {
            ["Commit"] = {
                strategy = "chat",
                description = "Generate commit from diff",
                opts = { short_name = "commit", is_slash_cmd = true, auto_submit = false },
                prompts = {
                    {
                        role = "system",
                        content = commit_prompt,
                        opts = { visible = false }
                    },
                    {
                        role = "user",
                        content = function(ctx)
                            if ctx.is_visual then
                                return string.format("```\n%s\n```", ctx.lines)
                            end
                            return string.format("```\n%s\n```",
                                require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.line_count))
                        end
                    }
                }
            }
        }
        -- opts = {
        --     log_level = "DEBUG"
        -- }
    },
    init = function()
        require("plugins.snacks_notifiers.codecompanion").setup()
    end
}
