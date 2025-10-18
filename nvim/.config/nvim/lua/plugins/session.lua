return {
  -- Auto session management
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
        auto_session_use_git_branch = false,

        auto_session_enable_last_session = false,
        auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = nil,
        auto_restore_enabled = nil,
        auto_session_create_enabled = nil,

        -- Session lens for browsing sessions
        session_lens = {
          buftypes_to_ignore = {},
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      })

      -- Keymaps for session management
      vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
      vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for cwd" })
      vim.keymap.set("n", "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", { desc = "Toggle autosave session" })
      vim.keymap.set("n", "<leader>wf", "<cmd>Telescope session-lens search_session<CR>", { desc = "Find sessions" })
    end,
  },

  -- Auto-save functionality
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },  -- Fixed typo: deferred not defered
      },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        if
          fn.getbufvar(buf, "&modifiable") == 1 and
          utils.not_in(fn.getbufvar(buf, "&filetype"), {}) and
          utils.not_in(fn.getbufvar(buf, "&buftype"), { 'nofile' }) then
          return true
        end
        return false
      end,
      write_all_buffers = false,
      debounce_delay = 1000,
      callbacks = {
        enabling = nil,
        disabling = nil,
        before_asserting_save = nil,
        before_saving = nil,
        after_saving = nil
      },
    },
    config = function(_, opts)
      require("auto-save").setup(opts)

      -- Keymaps for auto-save
      vim.keymap.set("n", "<leader>as", "<cmd>ASToggle<CR>", { desc = "Toggle auto-save" })
    end,
  },


  -- Enhanced session with view management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = vim.opt.sessionoptions:get(),
    },
    config = function(_, opts)
      require("persistence").setup(opts)
  
      -- Keymaps for persistence
      vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session for current dir" })
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save current session" })
    end,
  },
}
