function setup()
    local api = require("nvim-tree.api")
    local openfile = require 'nvim-tree.actions.node.open-file'
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    local view_selection = function (prompt_bufnr, map)
        actions.select_default:replace(function ()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            local filename = selection.filename
            if (filename == nil) then
                filename = selection[1]
            end
            openfile.fn('preview', filename)
        end)
        return true
    end

    function launch_live_grep(opts)
        return launch_telescope("live_grep", opts)
    end

    function launch_find_files(opts)
        return launch_telescope("find_files", opts)
    end

    function launch_telescope(func_name, opts)
        local telescope_status_ok, _ = pcall(require, "telescope")
        if not telescope_status_ok then
            return
        end
        local node = api.tree.get_node_under_cursor()
        local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false
        local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
        if (node.name == '..' and TreeExplorer ~= nil) then
            basedir = TreeExplorer.cwd
        end
        opts = opts or {}
        opts.cwd = basedir
        opts.search_dirs = { basedir }
        opts.attach_mappings = view_selection
        return require("telescope.builtin")[func_name](opts)
    end

    function find_file_and_focus()
        local function open_nvim_tree(prompt_bufnr, _)
            actions.select_default:replace(function ()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                api.tree.open()
                api.tree.find_file(selection.cwd .. "/" .. selection.value)
            end)
            return true
        end

        require("telescope.builtin").find_files({
            find_command = { "fd", "--hidden", "--exclude", ".git/*" },
            attach_mappings = open_nvim_tree,
        })
    end

    vim.keymap.set('n', '<c-f>', launch_find_files)
    vim.keymap.set('n', '<c-g>', launch_live_grep)
    vim.keymap.set("n", "ff", find_file_and_focus)

    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = 'NvimTree*',
        callback = function ()
            local api = require('nvim-tree.api')
            local view = require('nvim-tree.view')

            if not view.is_visible() then
                api.tree.open()
            end
        end,
    })
end

return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    config = function ()
        require("nvim-tree").setup()
        setup()
    end,
    -- cmd = "NvimTreeFindFile"
}
