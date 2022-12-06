local null_ls = require('null-ls')
local helpers = require('null-ls.helpers')
local vsg_lint = {
    name = "VSG",
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { "vhdl" },
    generator = helpers.generator_factory({
        command = "vsg",
        args = { "-c$ROOT/vsg_config.yaml", "--stdin", "-of=syntastic", "-p=1" },
        cwd = nil,
        check_exit_code = { 0, 1 },
        from_stderr = false,
        to_stdin = true,
        format = "line",
        multiple_files = false,
        on_output = helpers.diagnostics.from_patterns({
            {
                pattern = [[(%w+).*%((%d+)%)(.*)%s+%-%-%s+(.*)]],
                groups = { 'severity', 'row', 'code', 'message' },
                overrides = {
                    severities = {
                        ["ERROR"] = 2,
                        ["WARNING"] = 3,
                        ["INFORMATION"] = 3,
                        ["HINT"] = 4,
                    }
                }
            }
        }),
    })
}

local vsg_format = {
    name = "VSG Formatting",
    method = null_ls.methods.FORMATTING,
    filetypes = { "vhdl" },
    generator = helpers.formatter_factory({
        command = "vsg",
        args = { "-c$ROOT/vsg_config.yaml", "-f=$FILENAME", "-of=syntastic", "--fix" },
        cwd = nil,
        check_exit_code = { 0, 1 },
        from_stderr = false,
        to_temp_file = true,
        from_temp_file = true,
        to_stdin = false,
        multiple_files = false,
    })
}

null_ls.setup({
    diagnostics_format = "[#{c}] #{m} (#{s})",
    sources = { vsg_lint, vsg_format }
})
