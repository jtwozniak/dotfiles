return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "roobert/tailwindcss-colorizer-cmp.nvim",
  },

  opts = {
    inlay_hints = { enabled = true, focusable = true },

    servers = {
      ["*"] = {
        keys = {
          { "gr", false }, -- Disable default gr mapping
        },
      },
      oxlint = {
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          local root_file = vim.fs.find({
            "oxlint.config.ts",
            "pnpm-workspace.yaml",
            ".git",
          }, { path = fname, upward = true })[1]

          if root_file then
            on_dir(vim.fs.dirname(root_file))
          end
        end,
        -- keys = { { "<leader>fl", "<cmd>OxcFixAll<cr>", "Lint fix" } },
        keys = { { "<leader>fl", "<cmd>LspOxlintFixAll<cr><cmd>!pnpm exec oxfmt %<cr>", "Lint fix" } },
        -- settings = {
        --   typeAware = true,
        -- },
      },
    },

    setup = {
      tailwindcss = function(_, options)
        options.settings = {
          tailwindCSS = {
            colorDecorators = true,
            classAttributes = { "className", ".*ClassName" },
            classFunctions = { "clsx", "cn", "cva", "twMerge" },
          },
        }
      end,
    },
  },
}
