local editor = {}
local conf = require("modules.editor.config")

editor["junegunn/vim-easy-align"] = {opt = true, cmd = "EasyAlign"}
editor["itchyny/vim-cursorword"] = {
    opt = true,
    event = {"BufReadPre", "BufNewFile"},
    config = conf.vim_cursorwod
}
editor["terrortylor/nvim-comment"] = {
    opt = false,
    config = function()
        require("nvim_comment").setup({
            hook = function()
                require("ts_context_commentstring.internal").update_commentstring()
            end
        })
    end
}
editor["nvim-treesitter/nvim-treesitter"] = {
    opt = true,
    run = ":TSUpdate",
    after = "coc.nvim",
    config = conf.nvim_treesitter
}
editor["nvim-treesitter/nvim-treesitter-textobjects"] = {
    opt = true,
    after = "nvim-treesitter"
}
editor["romgrk/nvim-treesitter-context"] = {
    opt = true,
    after = "nvim-treesitter"
}
editor["p00f/nvim-ts-rainbow"] = {
    opt = true,
    after = "nvim-treesitter",
    event = "BufRead"
}
editor["JoosepAlviste/nvim-ts-context-commentstring"] = {
    opt = true,
    after = "nvim-treesitter"
}
editor["SmiteshP/nvim-gps"] = {
    opt = true,
    after = "nvim-treesitter",
    config = conf.nvim_gps
}
editor["windwp/nvim-ts-autotag"] = {
    opt = true,
    ft = {"html", "xml"},
    config = conf.autotag
}
editor["andymass/vim-matchup"] = {
    opt = true,
    after = "nvim-treesitter",
    config = conf.matchup
}
editor["rhysd/accelerated-jk"] = {opt = true}
editor["hrsh7th/vim-eft"] = {opt = true}
editor["romainl/vim-cool"] = {
    opt = true,
    event = {"CursorMoved", "InsertEnter"}
}
editor["phaazon/hop.nvim"] = {
    opt = true,
    branch = "v1",
    cmd = {
        "HopLine", "HopLineStart", "HopWord", "HopPattern", "HopChar1",
        "HopChar2"
    },
    config = function()
        require("hop").setup {keys = "etovxqpdygfblzhckisuran"}
    end
}
editor["lukas-reineke/format.nvim"] = {
    opt = true,
    cmd = {"Format", "FormatWrite"},
    config = conf.format
}
editor["karb94/neoscroll.nvim"] = {
    opt = true,
    event = "WinScrolled",
    config = conf.neoscroll
}
editor["vimlab/split-term.vim"] = {opt = true, cmd = {"Term", "VTerm"}}
editor["akinsho/nvim-toggleterm.lua"] = {
    opt = true,
    event = "BufRead",
    config = conf.toggleterm
}
editor["numtostr/FTerm.nvim"] = {opt = true, event = "BufRead"}
editor["mg979/vim-visual-multi"] = {opt = false, event = "BufRead"}
editor["norcalli/nvim-colorizer.lua"] = {
    opt = true,
    event = "BufRead",
    config = conf.nvim_colorizer
}
editor["rmagatti/auto-session"] = {
    opt = true,
    cmd = {"SaveSession", "RestoreSession", "DeleteSession"},
    config = conf.auto_session
}
editor["jdhao/better-escape.vim"] = {opt = true, event = "InsertEnter"}
editor["rcarriga/nvim-dap-ui"] = {
    opt = false,
    config = conf.dapui,
    requires = {
        {"mfussenegger/nvim-dap", config = conf.dap}, {
            "Pocco81/DAPInstall.nvim",
            opt = true,
            cmd = {"DIInstall", "DIUninstall", "DIList"},
            config = conf.dapinstall
        }
    }
}
editor["simrat39/symbols-outline.nvim"] = {
    disable = true, -- https://github.com/simrat39/symbols-outline.nvim/issues/98
    opt = false,
    config = conf.symbols_outline
}
editor["liuchengxu/vista.vim"] = {
    opt = true,
    after = "coc.nvim",
    config = conf.vista
}
editor["vimwiki/vimwiki"] = {opt = false, branch = "dev", config = conf.vimwiki}
return editor
