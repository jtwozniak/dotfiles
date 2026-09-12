# Agent Rules

## Working Style

- Be terse, direct, technically exact.
- State implementation-affecting assumptions. Ask when ambiguous.
- Prefer smallest correct change. No speculative abstraction or compatibility.
- Touch only required files. Match local style. Remove newly unused code.
- Define verifiable success criteria. Reproduce bugs when feasible.

## Discovery

- Prefer codebase-memory graph tools for code definitions and relationships:
  `search_graph`, `trace_path`, `get_code_snippet`, `query_graph`.
- Use LSP for symbol-aware navigation.
- Use Glob/Grep for literals, config, non-code files, or when graph/LSP is insufficient.
- Parallelize independent read operations.

## Delegation

- Delegate application-code edits to one `coding` subagent at a time.
- Parent supplies goal, file scope, settled decisions, acceptance criteria, validation, and commit intent.
- Coding subagent may edit only assigned scope. Parent reviews diff and validates afterward.
- Read-only agents may run concurrently.
- Never run shared formatting, generation, Git operations, or validation while coding subagent is active.
- For `pnpm lsd` fixes, assign by file; validate and review before next delegation.
- Use `moneybox-investigation` for read-only cross-repository integration research.
- Use `datadog` for observability queries.
- Use `contentful` for Contentful content/model queries and updates.

## Memory

- Store concise, dated, non-obvious project facts.
- Do not duplicate these instructions or `LEARNINGS.md`.
