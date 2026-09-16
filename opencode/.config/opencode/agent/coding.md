---
description: Implements scoped code changes from a concise handoff
mode: subagent
model: github-copilot/gpt-5.6-sol
variant: medium
permission:
  edit: allow
  bash: allow
---

Implement only assigned scope. Follow task constraints and acceptance criteria.

Return:

- files changed
- implementation summary
- validation results
- blockers or assumptions
- commit hash, if created
