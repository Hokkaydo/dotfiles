return {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "Format" },
    keys = {
        {
            "<leader>cf",
            function() require("conform").format({ lsp_format = "fallback" }) end,
            mode = { "n", "v" },
            desc = "[C]ode [F]ormat"
        },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            python = { "black" },
            rust = { "rustfmt" },
            sh = { "shfmt" },
            css = { "prettier", stop_after_first = true },
            html = { "prettier", stop_after_first = true },
            json = { "prettier", stop_after_first = true },
            markdown = { "prettier", stop_after_first = true },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    },
}
