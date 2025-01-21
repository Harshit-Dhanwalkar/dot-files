-- ~/.config/nvim/lua/profile.lua
local profile = {}

function profile.setup()
  local comp = require 'profile.components'
  -- local keymap_descriptions = {
  --   { key = '<leader>p', desc = 'Open Profile' },
  --   { key = 'o', desc = 'Open Recent Files (Telescope)' },
  --   { key = 'f', desc = 'Find Files (Telescope)' },
  --   { key = 'c', desc = 'Edit Neovim Config (Telescope)' },
  --   { key = '/', desc = 'Search Text (Telescope)' },
  --   { key = 'n', desc = 'Create New Buffer' },
  --   { key = 'l', desc = 'Open Lazy.nvim' },
  -- }
  local user_mappings = {
    n = {
      ['o'] = "<cmd>lua require('telescope.builtin').oldfiles()<cr>",
      ['f'] = "<cmd>lua require('telescope.builtin').find_files()<cr>",
      ['c'] = "<cmd>lua require('telescope.builtin').find_files({ cwd = '$HOME/.config/nvim' })<cr>",
      ['/'] = "<cmd>lua require('telescope.builtin').live_grep()<cr>",
      ['n'] = '<cmd>enew<cr>',
      ['l'] = '<cmd>Lazy<cr>',
    },
  }

  require('profile').setup {
    avatar_path = '/home/harshitpd/Pictures/Akin_doom/output.png',
    avatar_opts = {
      avatar_width = 30,
      avatar_height = 30,
      avatar_x = math.floor((vim.o.columns - 35) / 2),
      avatar_y = 7,
    },
    user = 'Harshit-Dhanwalkar',
    git_contributions = {
      start_week = 1,
      end_week = 53,
      empty_char = ' ',
      full_char = { '', '󰧞', '', '', '' },
      fake_contributions = nil,
    },
    hide = {
      statusline = true,
      tabline = true,
    },
    disable_move = true,
    cursor_pos = { 11, 121 },

    format = function()
      comp:avatar()
      comp:text_component_render {
        comp:text_component('git@github.com:Harshit-Dhanwalkar/profile.nvim', 'center', 'ProfileRed'),
        comp:text_component('──── By Harshit', 'right', 'ProfileBlue'),
      }
      -- comp:separator_render()
      -- comp:card_component_render {
      --   type = 'table',
      --   content = function()
      --     return {
      --       {
      --         title = 'Harshit-Dhanwalkar/llm.nvim',
      --         description = [[LLM Neovim Plugin: Effortless Natural Language Generation with LLM's API]],
      --       },
      --       {
      --         title = 'Harshit-Dhanwalkar/profile.nvim',
      --         description = [[My Personal Homepage]],
      --       },
      --     }
      --   end,
      --   hl = {
      --     border = 'ProfileYellow',
      --     text = 'ProfileYellow',
      --   },
      -- }

      -- For printing keymaps
      for _, keymap in ipairs(user_mappings) do
        comp:text_component_render {
          comp:text_component(keymap.key .. ': ' .. keymap.desc, 'left', 'ProfileGreen'),
        }
      end
      comp:separator_render()
      comp:git_contributions_render 'ProfileGreen'
      vim.cmd 'redraw'
    end,
  }
  vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>Profile<cr>', { silent = true })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'profile',
    callback = function()
      for mode, mapping in pairs(user_mappings) do
        for key, cmd in pairs(mapping) do
          vim.api.nvim_buf_set_keymap(0, mode, key, cmd, { noremap = true, silent = true })
        end
      end
    end,
  })
end

return profile
