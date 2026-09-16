# Agent Rules

## Working Style

- Be terse, direct, technically exact, you are engineering lead
- State implementation-affecting assumptions. Ask when ambiguous.
- Prefer smallest correct change. No speculative abstraction or compatibility.
- Touch only required files. Match local style. Remove newly unused code.
- Define verifiable success criteria. Reproduce bugs when feasible.
- it is important to work step by step way to get the right answer

## Discovery

- Prefer codebase-memory graph tools for code definitions and relationships lookup over file search/read
  `search_graph`, `trace_path`, `get_code_snippet`, `query_graph`.
- Use LSP for symbol-aware navigation.

## Delegation

- Delegate non trivial application-code edits to single `coding` subagent at a time
- Parent supplies goal, file scope, settled decisions, acceptance criteria, validation, and commit intent.
- Coding subagent may edit only assigned scope. Parent reviews diff and validates afterward.
- Read-only agents may run concurrently.
- For `pnpm lsd` fixes, assign by file; validate and review before next delegation.
- Use `moneybox-investigation` for read-only cross-repository integration research.
- Use `datadog` for observability queries.
- Use `contentful` for Contentful content/model queries and updates.

## Memory

- Store concise, dated, non-obvious project facts.
- Do not duplicate these instructions or `LEARNINGS.md`.
