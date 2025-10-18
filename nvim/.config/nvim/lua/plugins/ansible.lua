return {
  {
    "pearofducks/ansible-vim",
    ft = { "yaml", "yml" },
    config = function()
      vim.g.ansible_unindent_after_newline = 1
      vim.g.ansible_yamlKeyName = 'yamlKey'
      vim.g.ansible_attribute_highlight = "ob"
      vim.g.ansible_name_highlight = 'd'
      vim.g.ansible_extra_keywords_highlight = 1
    end,
  },
  {
    "mfussenegger/nvim-ansible",
    ft = { "yaml", "yaml.ansible" },
  },
  {
    'fcharlier/neovim-ansible-vault',
    ft = { 'yaml', 'yaml.ansible', 'ansible-vault' }, -- Load for YAML, Ansible YAML and vault files
    config = function()
      -- Optional configuration
      -- vim.g.ansible_vault_password_file = '~/.ansible/vault_pass'
      vim.g.ansible_vault_password_file = vim.fn.getcwd() .. '/vault_pass.txt'
      -- or - vim.g.ansible_vault_identity = 'default@~/.ansible/vault_pass'
    end,
  },
}

