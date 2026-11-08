---
name: refactor-docs
description: Refactor a directory or set of technical/design documents to eliminate redundancy, contradictions, and confusion. Enforces single-source-of-truth for definitions, prefers simplicity, and ensures math concepts reference their variables. Use when the user wants to consolidate, clean up, or refactor project documentation.
disable-model-invocation: true
metadata:
    opencode/autoinvoke: false
---

The user provides a directory or a list of documents.

1. Read every document in the provided scope. Do not begin refactoring until you confirm you have understood the full content.

2. Use the `question` tool when something is ambiguous or contradictory. Never guess.

3. Build a map of all definitions and concepts across the documents. Identify:
   - Concepts defined in multiple places (redundancy).
   - Definitions that contradict each other.
   - Concepts that reference undefined terms.

Confirm this map with the user before proceeding.

4. Divide the refactored output into sections based on headings. Treat information as a directed acyclic graph: if concept B depends on concept A, then A must appear before B. Confirm the section order with the user.

5. For each section:

5a. Each definition or concept must be written in exactly one place. Remove all duplicates and replace them with a reference to the single source.

5b. Prefer simple phrasing over over-explanation. Cut verbosity aggressively.

5c. Mathematical concepts must include references to the variables they use and a brief explanation of their formula.

5d. Maximum ~240 characters per paragraph.

6. After all sections are rewritten, present the full refactored result for the user to review.
