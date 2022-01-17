local config = {}

function config.edge()
  vim.cmd [[set background=light]]
  vim.g.edge_style = "aura"
  vim.g.edge_enable_italic = 1
  vim.g.edge_disable_italic_comment = 1
  vim.g.edge_show_eob = 1
  vim.g.edge_better_performance = 1
end

function config.tokyonight()
  vim.g.tokyonight_style = "day"
  vim.g.tokyonight_italic_variables = 1
  vim.g.tokyonight_transparent = 0
  vim.g.tokyonight_day_brightness = 0.4
end

function config.lualine()
  local gps = require("nvim-gps")

  local function gps_content()
    if gps.is_available() then
        return gps.get_location()
    else
        return ""
    end
  end

  local function location()
    local is_visual_mode = vim.api.nvim_get_mode().mode == 'v'
    local total_column = tostring(vim.fn.col('$') - 1)
    local location_info = "%l/%L %c/"..total_column
    if is_visual_mode then
      local visual_append_info = tostring(math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1)
      location_info = location_info ..' 礪' .. visual_append_info
    end
    return location_info
  end

  local lsp_symbols = {error = " ", warn = " ", info = " ", hint = " ", ok = "ﮒ"}
  local lsp_colors  = {error = {bg = "#f19072", fg = "#425066"},
                        warn = {bg = "#E7C482", fg = "#425066"},
                        info = {bg = "#D3D9E5", fg = "#425066"},
                        hint = {bg = "#89c3eb", fg = "#425066"},
                        ok   = {bg = "#a4e2c6", fg = "#425066"}}

  local diagnostic_section = function(cfg)
    local default_cfg = {
        "diagnostics",
        source = {'coc'},
        separator = {left = " ", right = ""},
        padding = 0,
        fmt = function(status)
            if tonumber(status, 10) > 0 then
                return cfg.leading..string.format(' %s%s ', cfg.symbol, status)
            end
            return ''
        end,
        symbols = {error = '', warn = '', hint = '', info = ''}, -- cover default symbols
        colored = false,
        always_visible = true,
        cond = function() return vim.fn['coc#status'] ~= '' end
    }
    return vim.tbl_extend("force", default_cfg, cfg)
  end

  require("lualine").setup {
      options = {
          icons_enabled = true,
          theme = "auto", -- solarized for space-vim
          disabled_filetypes = {},
          component_separators = {left = "", right = ""},
          section_separators = {left = "", right = ""},
          always_divide_middle = true,
      },
      sections = {
          lualine_a = {"mode"},
          lualine_b = {
            {"branch"},
            {"diff",symbols = {added = ' ', modified = ' ', removed = ' '}},
            {'filetype',
              colored = true, icon_only = true, separator = '',
              padding = { left = 1, right = 0 }
            },
            {"filename",
              file_status = true, path = 0,
              symbols = {modified = '[⨦]', readonly = '[]', unnamed = '[λ]'}
            }
          },
          lualine_c = {{gps_content, cond = gps.is_available}},
          lualine_x = {
            diagnostic_section {
              sections = {'error'}, color = lsp_colors.error, symbol = lsp_symbols.error, leading = ''
            }, diagnostic_section {
              sections = {'warn'}, color = lsp_colors.warn, symbol = lsp_symbols.warn, leading = ' '
            }, diagnostic_section {
              sections = {'info'}, color = lsp_colors.info, symbol = lsp_symbols.info, leading = ' '
            }, diagnostic_section {
              sections = {'hint'}, color = lsp_colors.hint, symbol = lsp_symbols.hint, leading = ' '
            }, diagnostic_section {
              sections = {'error', 'warn', 'hint', 'info'},
              color = lsp_colors.ok,
              fmt = function(status)
                  if status == "0 0 0 0" then
                      return string.format(" %s ", lsp_symbols.ok)
                  end
                  return ''
              end
            },
          },
          lualine_y = {
              {"filetype"}, {"encoding", separator=''},
              {"fileformat",
                padding = {left = 0, right = 1},
                symbols = {unix = vim.loop.os_uname().sysname == 'Darwin' and '' or '', dos = '', mac = '',}
              }
          },
          lualine_z = {{"progress", fmt = function(progress) return " "..os.date('%m/%d %a')..'  '..''..progress end}, {location}}
      },
      inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {"filename"},
          lualine_x = {"location"},
          lualine_y = {},
          lualine_z = {}
      },
      tabline = {},
      extensions = {"quickfix", "nvim-tree", "toggleterm", "fugitive"}
  }
end

function config.nvim_tree()
    local tree_cb = require"nvim-tree.config".nvim_tree_callback
    require("nvim-tree").setup {
        open_on_tab = false,
        open_on_setup = true,
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = false,
        auto_close = false,
        update_cwd = true,
        highlight_opened_files = true,
        auto_ignore_ft = {"startify", "dashboard"},
        update_to_buf_dir   = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {}
        },
        diagnostics = {
            enable = true,
            icons = { hint = "", info = "", warning = "", error = ""}
        },
        system_open = {
            cmd  = nil, args = {}
        },
        filters = {
            dotfiles = false,
            custom = {".DS_Store"}
        },
        git = {
            enable = true,
            ignore = true,
            timeout = 500,
        },
        trash = {
            cmd = "trash",
            require_confirm = true
        },
        view = {
            width = 30,
            side = "left",
            auto_resize = true,
            signcolumn = "yes",
            mappings = {
                custom_only = true,
                -- list of mappings to set on the tree manually
                list = {
                    {
                        key = {"<CR>", "o", "<2-LeftMouse>"},
                        cb = tree_cb("edit")
                    }, {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
                    {key = "<C-v>", cb = tree_cb("vsplit")},
                    {key = "<C-x>", cb = tree_cb("split")},
                    {key = "<C-t>", cb = tree_cb("tabnew")},
                    {key = "<", cb = tree_cb("prev_sibling")},
                    {key = ">", cb = tree_cb("next_sibling")},
                    {key = "P", cb = tree_cb("parent_node")},
                    {key = "<BS>", cb = tree_cb("close_node")},
                    {key = "<S-CR>", cb = tree_cb("close_node")},
                    {key = "<Tab>", cb = tree_cb("preview")},
                    {key = "K", cb = tree_cb("first_sibling")},
                    {key = "J", cb = tree_cb("last_sibling")},
                    {key = "I", cb = tree_cb("toggle_ignored")},
                    {key = "H", cb = tree_cb("toggle_dotfiles")},
                    {key = "R", cb = tree_cb("refresh")},
                    {key = "a", cb = tree_cb("create")},
                    {key = "d", cb = tree_cb("remove")},
                    {key = "r", cb = tree_cb("rename")},
                    {key = "<C-r>", cb = tree_cb("full_rename")},
                    {key = "x", cb = tree_cb("cut")},
                    {key = "c", cb = tree_cb("copy")},
                    {key = "p", cb = tree_cb("paste")},
                    {key = "y", cb = tree_cb("copy_name")},
                    {key = "Y", cb = tree_cb("copy_path")},
                    {key = "gy", cb = tree_cb("copy_absolute_path")},
                    {key = "[c", cb = tree_cb("prev_git_item")},
                    {key = "]c", cb = tree_cb("next_git_item")},
                    {key = "-", cb = tree_cb("dir_up")},
                    {key = "s", cb = tree_cb("system_open")},
                    {key = "q", cb = tree_cb("close")},
                    {key = "g?", cb = tree_cb("toggle_help")}
                }
            }
        }
    }
    vim.g.nvim_tree_symlink_arrow = ' → '
    vim.g.nvim_tree_indent_markers = 1
end

function config.nvim_bufferline()
    require("bufferline").setup {
        options = {
            numbers = "ordinal",
            indicator_icon = '▎',
            modified_icon = "●",
            buffer_close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 18,
            max_prefix_length = 15,
            tab_size = 18,
            show_buffer_close_icons = true,
            show_buffer_icons = true,
            show_tab_indicators = true,
            diagnostics = "coc",
            always_show_bufferline = true,
            separator_style = "thin",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = " File Explorer",
                    text_align = "center",
                    padding = 1
                }
            },
        }
    }
end

function config.gitsigns()
    if not packer_plugins["plenary.nvim"].loaded then
        vim.cmd [[packadd plenary.nvim]]
    end
    require("gitsigns").setup {
        signs = {
            add = {hl = "GitGutterAdd", text = "▋"},
            change = {hl = "GitGutterChange", text = "▋"},
            delete = {hl = "GitGutterDelete", text = "▋"},
            topdelete = {hl = "GitGutterDeleteChange", text = "▔"},
            changedelete = {hl = "GitGutterChange", text = "▎"}
        },
        keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,
            ["n ]g"] = {
                expr = true,
                '&diff ? \']g\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''
            },
            ["n [g"] = {
                expr = true,
                '&diff ? \'[g\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''
            },
            ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
            ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
            -- Text objects
            ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
            ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>'
        },
        watch_gitdir = {interval = 1000, follow_files = true},
        current_line_blame = true,
        current_line_blame_opts = {delay = 1000, virtual_text_pos = "eol"},
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        diff_opts = {internal = true}
    }
end

function config.indent_blankline()
    -- vim.cmd [[highlight IndentTwo guifg=#D08770 guibg=NONE gui=nocombine]]
    -- vim.cmd [[highlight IndentThree guifg=#EBCB8B guibg=NONE gui=nocombine]]
    -- vim.cmd [[highlight IndentFour guifg=#A3BE8C guibg=NONE gui=nocombine]]
    -- vim.cmd [[highlight IndentFive guifg=#5E81AC guibg=NONE gui=nocombine]]
    -- vim.cmd [[highlight IndentSix guifg=#88C0D0 guibg=NONE gui=nocombine]]
    -- vim.cmd [[highlight IndentSeven guifg=#B48EAD guibg=NONE gui=nocombine]]
    -- vim.g.indent_blankline_char_highlight_list = {
    --     "IndentTwo", "IndentThree", "IndentFour", "IndentFive", "IndentSix",
    --     "IndentSeven"
    -- }
    require("indent_blankline").setup {
        char = "│",
        show_first_indent_level = true,
        filetype_exclude = {
            "startify", "dashboard", "dotooagenda", "log", "fugitive",
            "gitcommit", "packer", "vimwiki", "markdown", "json", "txt",
            "vista", "help", "todoist", "NvimTree", "peekaboo", "git",
            "TelescopePrompt", "undotree", "flutterToolsOutline", "" -- for all buffers without a file type
        },
        buftype_exclude = {"terminal", "nofile"},
        show_trailing_blankline_indent = false,
        show_current_context = true,
        context_patterns = {
            "class", "function", "method", "block", "list_literal", "selector",
            "^if", "^table", "if_statement", "while", "for", "type", "var",
            "import"
        }
    }
    -- because lazy load indent-blankline so need readd this autocmd
    vim.cmd("autocmd CursorMoved * IndentBlanklineRefresh")
end

return config
