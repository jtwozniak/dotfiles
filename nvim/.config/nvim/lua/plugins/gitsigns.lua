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
  },
}
