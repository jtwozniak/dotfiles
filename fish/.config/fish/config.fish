# ~/.config/fish/config.fish

fish_vi_key_bindings

#macos
if test -d /opt/homebrew/bin
    /opt/homebrew/bin/brew shellenv | source
end

# SSH agent
eval (ssh-agent -c)
ssh-add ~/.ssh/github 2>/dev/null

# aliases
alias run='pnpm'
alias cop='/home/jtw/.local/bin/copilot --model GPT-5.4-xhigh --deny-tool=delete --deny-tool=remove'
alias gem='pnpm gemini --approval-mode=yolo'
alias code='OPENCODE_EXPERIMENTAL_LSP_TOOL=true OPENCODE_CONFIG=~/.config/opencode/options.jsonc headroom wrap opencode --code-graph'
# alias code='OPENCODE_EXPERIMENTAL_LSP_TOOL=true OPENCODE_CONFIG=~/.config/opencode/options.jsonc headroom wrap opencode --code-graph --prompt "Activate serena_activate_project"'
alias code-slim='OPENCODE_DISABLE_LSP_DOWNLOAD=true OPENCODE_CONFIG=~/.config/opencode/options.jsonc opencode'

# evns 
# opencode mcp config with secrets
set -gx OPENCODE_CONFIG .config/opencode/
set -gx PATH "$HOME/.local/bin" $PATH
set -gx HUSKY 0

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# ASDF
set -gx PATH "$HOME/.asdf/shims" $PATH

# Added by codebase-memory-mcp install
fish_add_path /home/jtw/.local/bin
