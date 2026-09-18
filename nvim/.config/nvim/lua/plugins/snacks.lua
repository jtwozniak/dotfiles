return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts = opts or {}
    local snacks = require("config.snacks")
    opts.profiler = { enabled = false }
    opts.notifier = { enabled = true }
    opts.picker = opts.picker or {}
    opts.picker.actions = opts.picker.actions or {}
    opts.picker.actions.copy_relative_path = snacks.copy_relative_path
    opts.picker.actions.git_log_dir = snacks.git_log_dir
    opts.picker.actions.explorer_toggle_dirty = snacks.explorer_toggle_dirty
    opts.picker.actions.explorer_toggle_develop = snacks.explorer_toggle_develop
    opts.picker.sources = opts.picker.sources or {}
    opts.picker.sources.explorer = vim.tbl_deep_extend("force", opts.picker.sources.explorer or {}, {
      transform = snacks.explorer_git_transform,
      layout = {
        layout = {
          position = "right",
          width = 0.3,
        },
      },
      win = {
        input = {
          keys = {
            ["gf"] = { "git_log_dir", mode = "n", desc = "Git Log (directory)" },
          },
        },
        list = {
          keys = {
            ["Y"] = { "copy_relative_path", mode = { "n", "x" }, desc = "Copy Relative Path" },
            ["gf"] = { "git_log_dir", desc = "Git Log (directory)" },
            ["D"] = { "explorer_toggle_dirty", desc = "Toggle modified files" },
            ["M"] = { "explorer_toggle_develop", desc = "Toggle files vs develop" },
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>gb", "<Cmd>Gvdiffsplit<CR>", desc = "Compare current branch" },
    { "<leader>gm", "<Cmd>Gvdiffsplit develop<CR>", desc = "Compare develop" },
    {
      "<leader>gd",
      function()
        require("config.snacks").grep_dirty()
      end,
      desc = "Grep dirty files",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status Files",
    },
    {
      "<leader>gM",
      function()
        Snacks.picker.git_diff({ base = "develop", group = true })
      end,
      desc = "Git files vs develop",
    },
    {
      "<leader>ga",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub PRs (open)",
    },
    {
      "<leader>gj",
      function()
        Snacks.picker.gh_pr({ search = "is:open involves:@me" })
      end,
      desc = "GitHub PRs (involves me)",
    },
    {
      "<leader>go",
      function()
        Snacks.picker.gh_pr({ search = "is:open review-requested:@me" })
      end,
      desc = "GitHub PRs (review requested)",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references({
          include_declaration = false,
          auto_confirm = true, -- Jumps automatically if only 1 item remains
          jump = { reuse_win = true },

          -- 'transform' is called for every item. Return false to drop it.
          transform = function(item)
            -- 1. Skip test files
            local file = item.file or vim.uri_to_fname(item.uri)
            if file:match("%.test%.") or file:match("%.spec%.") then
              return false
            end

            -- 2. Skip import lines
            local text = item.text or ""
            local trimmed = text:match("^%s*(.-)%s*$") or ""

            local is_import = trimmed:match("^import[%s{(]")
              or trimmed:match("from%s+['\"]")
              or (trimmed:match("^[%w_]+%s*,?$") and not (trimmed:match("=") or trimmed:match("%(")))

            return not is_import and item or false
          end,
        })
      end,
      desc = "Smart References",
    },
    {
      "gt",
      function()
        Snacks.picker.lsp_references({
          include_declaration = false,
        })
      end,
      desc = "References (with tests)",
      mode = "n",
      nowait = true,
    },
  },
}
