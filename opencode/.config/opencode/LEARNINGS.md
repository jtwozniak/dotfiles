# Learnings

Durable coding-session knowledge. Referenced automatically on start.

## Validation workflow

After every file modification, run `pnpm lsd` from repo root as the fast validation loop. It runs `nano-staged --unstaged` with autofix plus relevant checks, so it validates only unstaged changed files and may fix supported issues.

Run full validation from repo root only when the user explicitly requests it:

```sh
NODE_OPTIONS='' pnpm ta
```

Clearing `NODE_OPTIONS` disables the environment-injected Headroom hook shim, which otherwise makes Turbo child processes fail with a missing `HEADROOM_OPENCODE_TRANSPORT_PROXY_URL` error. Report when full validation was not run.
