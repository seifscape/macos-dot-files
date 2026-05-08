return {
  "phaazon/hop.nvim",
  branch = "v1",
  event = "VeryLazy",
  config = function()
    require("hop").setup()
  end,
  keys = {
    { "s", "<cmd>HopChar2<CR>", mode = { "n", "v" }, desc = "Hop 2-char" },
  },
}
