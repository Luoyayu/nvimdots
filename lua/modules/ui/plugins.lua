local ui = {}
local conf = require("modules.ui.config")

ui["kyazdani42/nvim-web-devicons"] = {opt = false}
-- colorschemes
ui["sainnhe/edge"] = {opt = false, config = conf.edge}
ui["liuchengxu/space-vim-theme"] = {opt = false}
ui["folke/tokyonight.nvim"] = {opt = false, config = conf.tokyonight}

ui["hoob3rt/lualine.nvim"] = {
    opt = true,
    after = "nvim-gps",
    config = conf.lualine
}
ui["glepnir/dashboard-nvim"] = {opt = true, event = "BufWinEnter"}
ui["kyazdani42/nvim-tree.lua"] = {
    opt = true,
    cmd = {"NvimTreeToggle", "NvimTreeOpen"},
    config = conf.nvim_tree,
    requires = {'kyazdani42/nvim-web-devicons'},
}
ui["lewis6991/gitsigns.nvim"] = {
    opt = true,
    event = {"BufRead", "BufNewFile"},
    config = conf.gitsigns,
    requires = {"nvim-lua/plenary.nvim", opt = true}
}
ui["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    event = "BufRead",
    config = conf.indent_blankline
}
ui["akinsho/nvim-bufferline.lua"] = {
    opt = true,
    event = "BufRead",
    config = conf.nvim_bufferline
}

return ui
