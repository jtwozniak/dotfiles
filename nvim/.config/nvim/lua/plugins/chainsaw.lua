return {
  {
    "chrisgrieser/nvim-chainsaw",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>p", "", desc = "+print", mode = { "n", "x" } },
      {
        "<leader>pv",
        function()
          require("chainsaw").variableLog()
        end,
        mode = { "n", "x" },
        desc = "Print variable",
      },
      {
        "<leader>po",
        function()
          require("chainsaw").objectLog()
        end,
        mode = { "n", "x" },
        desc = "Print object",
      },
      {
        "<leader>pm",
        function()
          require("chainsaw").messageLog()
        end,
        desc = "Print message",
      },
      {
        "<leader>pd",
        function()
          require("chainsaw").debugLog()
        end,
        desc = "Print debugger",
      },
      {
        "<leader>px",
        function()
          require("chainsaw").removeLogs()
        end,
        mode = { "n", "x" },
        desc = "Remove print logs",
      },
    },
  },
  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>p", false },
      {
        "<leader>P",
        function()
          Snacks.picker.yanky()
        end,
        mode = { "n", "x" },
        desc = "Open Yank History",
      },
    },
  },
}
