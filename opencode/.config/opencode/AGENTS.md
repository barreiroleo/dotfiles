## General rules

1. Do not inspect external library or generated code (`node_modules`, `vendor`, `dist`, `build`, etc.).
2. Report inconsistencies between code and documentation.

## Workflow rules

1. Divide complex tasks into steps and briefly justify each.
1. Implement one agreed change at a time, in small increments. Allow review before proceeding.
1. After five failures on the same check, stop and ask for a plan.
1. If a subagent fails, do not take over its task.
1. If a subagent completes with build and tests passing, do not rerun them.

## Design and coding rules

1. For new components or significant changes, propose a concise architecture and API. Wait for approval.
1. Prefer simple, concrete solutions. Use patterns and abstractions when they reduce complexity.
1. Write short, clearly named functions with a single responsibility.
1. Prefer explicit, intention-revealing code over clever or tricky solutions.
   When complexity is justified by performance or optimization, briefly comment on its rationale.
1. Consider refactoring:
   - Functions with >30 lines or >4 arguments.
   - Files with >250 lines.

## Testing rules

1. Keep tests simple. Avoid testing trivial behavior, obvious checks, or library behavior.

## Writing rules

1. Remove redundant, incorrect, outdated, or contextless text.
1. Rewrite for clarity and concision. Reread as a new reader before finishing.
1. Do not join a statement and its explanation with a colon or semicolon ("X: Y", "X; Y").
   Write separate sentences or use a connector (porque, así que, pero). Colons only before lists, examples or code.

## Tool rules

1. Prefer `tool browser` over `chrome-devtools` when available.
1. Ask to delegate heavy tasks to subagents (MCPs, documentation research, etc.).
