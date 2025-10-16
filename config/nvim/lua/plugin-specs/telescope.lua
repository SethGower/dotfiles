config = function ()
    local Path = require 'plenary.path'
    local action_set = require 'telescope.actions.set'
    local action_state = require 'telescope.actions.state'
    local transform_mod = require('telescope.actions.mt').transform_mod
    local actions = require 'telescope.actions'
    local conf = require('telescope.config').values
    local finders = require 'telescope.finders'
    local make_entry = require 'telescope.make_entry'
    local os_sep = Path.path.sep
    local pickers = require 'telescope.pickers'
    local scan = require 'plenary.scandir'

    -- https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1690573382

    local telescope_utils = require 'telescope.utils'
    local make_entry = require 'telescope.make_entry'
    local entry_display = require 'telescope.pickers.entry_display'

    ---- Helper functions ----

    ---Gets the File Path and its Tail (the file name) as a Tuple
    ---@param file_name string
    ---@return string, string
    function get_path_and_tail(file_name)
        local buffer_name_tail = telescope_utils.path_tail(file_name)

        local path_without_tail = require('plenary.strings').truncate(file_name, #file_name - #buffer_name_tail, '')

        local path_to_display = telescope_utils.transform_path({
                                                                   path_display = { 'truncate' },
                                                               }, path_without_tail)

        return buffer_name_tail, path_to_display
    end

    ---- Picker functions ----

    -- Generates a Grep Search picker but beautified
    -- ----------------------------------------------
    -- This is a wrapping function used to modify the appearance of pickers that provide Grep Search
    -- functionality, mainly because the default one doesn't look good. It does this by changing the 'display()'
    -- function that Telescope uses to display each entry in the Picker.
    --
    -- @param (table) picker_and_options - A table with the following format:
    --                                   {
    --                                      picker = '<pickerName>',
    --                                      (optional) options = { ... }
    --                                   }
    function pretty_grep_picker(picker_and_options)
        if type(picker_and_options) ~= 'table' or picker_and_options.picker == nil then
            print "Incorrect argument format. Correct format is: { picker = 'desiredPicker', (optional) options = { ... } }"
            return
        end

        local options = picker_and_options.options or {}

        -- Use Telescope's existing function to obtain a default 'entry_maker' function
        -- ----------------------------------------------------------------------------
        -- INSIGHT: Because calling this function effectively returns an 'entry_maker' function that is ready to
        --          handle entry creation, we can later call it to obtain the final entry table, which will
        --          ultimately be used by Telescope to display the entry by executing its 'display' key function.
        --          This reduces our work by only having to replace the 'display' function in said table instead
        --          of having to manipulate the rest of the data too.
        local original_entry_maker = make_entry.gen_from_vimgrep(options)

        -- INSIGHT: 'entry_maker' is the hardcoded name of the option Telescope reads to obtain the function that
        --          will generate each entry.
        -- INSIGHT: The paramenter 'line' is the actual data to be displayed by the picker, however, its form is
        --          raw (type 'any) and must be transformed into an entry table.
        options.entry_maker = function (line)
            -- Generate the Original Entry table
            local original_entry_table = original_entry_maker(line)

            -- INSIGHT: An "entry display" is an abstract concept that defines the "container" within which data
            --          will be displayed inside the picker, this means that we must define options that define
            --          its dimensions, like, for example, its width.
            local displayer = entry_display.create {
                separator = ' ', -- Telescope will use this separator between each entry item
                items = {
                    { width = nil },
                    { width = nil }, -- Maximum path size, keep it short
                    { remaining = true },
                },
            }

            -- LIFECYCLE: At this point the "displayer" has been created by the create() method, which has in turn
            --            returned a function. This means that we can now call said function by using the
            --            'displayer' variable and pass it actual entry values so that it will, in turn, output
            --            the entry for display.
            --
            -- INSIGHT: We now have to replace the 'display' key in the original entry table to modify the way it
            --          is displayed.
            -- INSIGHT: The 'entry' is the same Original Entry Table but is is passed to the 'display()' function
            --          later on the program execution, most likely when the actual display is made, which could
            --          be deferred to allow lazy loading.
            --
            -- HELP: Read the 'make_entry.lua' file for more info on how all of this works
            original_entry_table.display = function (entry)
                ---- Get File columns data ----
                -------------------------------

                local tail, path_to_display = get_path_and_tail(entry.filename)

                ---- Format Text for display ----
                ---------------------------------

                -- Add coordinates if required by 'options'
                local coordinates = ''

                if not options.disable_coordinates then
                    if entry.lnum then
                        if entry.col then
                            coordinates = string.format('%s:%s', entry.lnum, entry.col)
                        else
                            coordinates = string.format('%s', entry.lnum)
                        end
                    end
                end

                -- Encode text if necessary
                local text = options.file_encoding and vim.iconv(entry.text, options.file_encoding, 'utf8') or entry
                .text

                -- INSIGHT: This return value should be a tuple of 2, where the first value is the actual value
                --          and the second one is the highlight information, this will be done by the displayer
                --          internally and return in the correct format.
                return displayer {
                    tail,
                    { coordinates,     'TelescopeResultsComment' },
                    { path_to_display, 'TelescopeResultsComment' },
                    text,
                }
            end

            return original_entry_table
        end

        -- Finally, check which file picker was requested and open it with its associated options
        if picker_and_options.picker == 'live_grep' then
            require('telescope.builtin').live_grep(options)
        elseif picker_and_options.picker == 'grep_string' then
            require('telescope.builtin').grep_string(options)
        elseif picker_and_options.picker == '' then
            print 'Picker was not specified'
        else
            print 'Picker is not supported by Pretty Grep Picker'
        end
    end

    ---Keep track of the active extension and folders for `live_grep`
    local live_grep_filters = {
        ---@type nil|string
        extension = nil,
        ---@type nil|string[]
        directories = nil,
    }

    ---Run `live_grep` with the active filters (extension and folders)
    ---@param current_input ?string
    local function run_live_grep(current_input)
        -- TODO: Resume old one with same options somehow
        -- TODO: Use path_display with default live_grep if possible here
        pretty_grep_picker {
            picker = 'live_grep',
            options = {
                additional_args = live_grep_filters.extension and function ()
                    return { '-g', '*.' .. live_grep_filters.extension }
                end,
                search_dirs = live_grep_filters.directories,
                default_text = current_input,
            },
        }
    end

    actions = transform_mod {
        ---Ask for a file extension and open a new `live_grep` filtering by it
        set_extension = function (prompt_bufnr)
            local current_input = action_state.get_current_line()

            vim.ui.input({ prompt = '*.' }, function (input)
                if input == nil then
                    return
                end

                live_grep_filters.extension = input

                actions.close(prompt_bufnr)
                run_live_grep(current_input)
            end)
        end,
        ---Ask the user for a folder and olen a new `live_grep` filtering by it
        set_folders = function (prompt_bufnr)
            local current_input = action_state.get_current_line()

            local data = {}
            scan.scan_dir(vim.loop.cwd(), {
                hidden = true,
                only_dirs = true,
                respect_gitignore = true,
                on_insert = function (entry)
                    table.insert(data, entry .. os_sep)
                end,
            })
            table.insert(data, 1, '.' .. os_sep)

            actions.close(prompt_bufnr)
            pickers
                .new({}, {
                    prompt_title = 'Folders for Live Grep',
                    finder = finders.new_table { results = data, entry_maker = make_entry.gen_from_file {} },
                    previewer = conf.file_previewer {},
                    sorter = conf.file_sorter {},
                    attach_mappings = function (prompt_bufnr)
                        action_set.select:replace(function ()
                            local current_picker = action_state.get_current_picker(prompt_bufnr)

                            local dirs = {}
                            local selections = current_picker:get_multi_selection()
                            if vim.tbl_isempty(selections) then
                                table.insert(dirs, action_state.get_selected_entry().value)
                            else
                                for _, selection in ipairs(selections) do
                                    table.insert(dirs, selection.value)
                                end
                            end
                            live_grep_filters.directories = dirs

                            actions.close(prompt_bufnr)
                            run_live_grep(current_input)
                        end)
                        return true
                    end,
                })
                :find()
        end,
    }

    ---Small wrapper over `live_grep` to first reset our active filters
    live_grep = function ()
        live_grep_filters.extension = nil
        live_grep_filters.directories = nil

        run_live_grep()
    end

    require("telescope").setup {
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case"
            },
            prompt_prefix = "  ",
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "normal",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "bottom",
                    preview_width = 0.55,
                    results_width = 0.8
                },
                vertical = {
                    mirror = false
                },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120
            },
            --file_sorter = require "telescope.sorters".get_fuzzy_file,
            file_ignore_patterns = {
                "%.git/*",
                "%.vim/*",
                "docs/doxygen/*",
                "doxygen/*",
                "zig-cache/*",
                "zig-out/*"
            },
            --generic_sorter = require "telescope.sorters".get_generic_fuzzy_sorter,
            --path_display = {"smart", "shorten"}, -- TODO: truncate when required by shortening path
            dynamic_preview_title = true,
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            use_less = true,
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
            file_previewer = require "telescope.previewers".vim_buffer_cat.new,
            grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
            qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require "telescope.previewers".buffer_previewer_maker,
            -- preview = {
            --     treesitter = true
            -- },
        },
        extensions = {
            -- fzf = {
            --     fuzzy = true,                   -- false will only do exact matching
            --     override_generic_sorter = true, -- override the generic sorter
            --     override_file_sorter = true,    -- override the file sorter
            --     case_mode = "smart_case"        -- or "ignore_case" or "respect_case"
            --     -- the default case_mode is "smart_case"
            -- },
            -- media_files = {
            --     filetypes = { "png", "webp", "jpg", "jpeg" },
            --     find_cmd = "rg" -- find command (defaults to `fd`)
            -- }
        },
        pickers = {
            find_files = {
                hidden = true,
            },
            live_grep = {
                path_display = { 'shorten' },
                mappings = {
                    i = {
                        ['<c-f>'] = actions.set_extension,
                        ['<c-l>'] = actions.set_folders,
                    },
                },
            }
            --grep_string = {
            --    shorten_path = true,
            --    word_match = "-w",
            --    only_sort_text = true,
            --    search = ''
            --},
            -- find_files = {
            --     find_command = {
            --         "rg", "--ignore", "--hidden", "--files"
            --     }
            -- }
        }
    }

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("media_files")


    -- configure the mappings for telescope
    require("mappings").telescope()
end

return {
    { -- Fuzzy search
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
        },
        event = { "BufEnter" },
        config = function ()
            config()
        end
    },

    { -- Telescope plugins
        {
            'rmagatti/session-lens',
            config = function ()
                require("telescope").load_extension("session-lens")
                require('session-lens').setup({
                    path_display = { 'shorten' },
                    previewer = true
                })
            end,
        },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "olacin/telescope-gitmoji.nvim" },
        lazy = true,
    },
}
