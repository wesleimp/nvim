return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "jfpedroza/neotest-elixir",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    require("neotest").setup({
      icons = {
        running_animated = {
          "⠋",
          "⠙",
          "⠹",
          "⠸",
          "⠼",
          "⠴",
          "⠦",
          "⠧",
          "⠇",
          "⠏",
        },
      },
      adapters = {
        require("neotest-elixir"),
        require("neotest-jest"),
      },
    })
  end,
}
