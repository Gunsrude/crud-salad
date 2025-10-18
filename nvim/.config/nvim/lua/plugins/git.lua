return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    config = function()
      -- Keymaps for Fugitive
      vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
      vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
      vim.keymap.set("n", "<leader>gl", "<cmd>Git pull<CR>", { desc = "Git pull" })
      vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
      vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })
      vim.keymap.set("n", "<leader>gh", "<cmd>0Gclog<CR>", { desc = "Git file history" })
    end,
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        kind = "floating",
      })
      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Open Neogit" })
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    config = function()
      require("diffview").setup()
      vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
      vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "File history" })
    end,
  },
}
