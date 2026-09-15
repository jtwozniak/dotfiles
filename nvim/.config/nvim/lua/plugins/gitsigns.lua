return {
  "lewis6991/gitsigns.nvim",
  keys = {
    {
      "<leader>gc",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview hunk",
    },
    {
      "<leader>gt",
      function()
        local gs = require("gitsigns")
        if vim.g.gitsigns_develop_review then
          gs.reset_base(true)
          vim.g.gitsigns_develop_review = false
          vim.notify("Gitsigns: index")
          return
        end
        local root = vim.fs.root(0, ".git") or vim.uv.cwd()
        local result = vim.system({ "git", "merge-base", "develop", "HEAD" }, {
          cwd = root,
          text = true,
          timeout = 5000,
        }):wait()
        local sha = vim.trim(result.stdout or "")
        if result.code ~= 0 or sha == "" then
          vim.notify("Could not resolve develop merge-base", vim.log.levels.WARN)
          return
        end
        gs.change_base(sha, true)
        vim.g.gitsigns_develop_review = true
        vim.notify("Gitsigns: develop (" .. sha:sub(1, 7) .. ")")
      end,
      desc = "Toggle gitsigns vs develop",
    },
  },
}
