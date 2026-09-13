return {
    'mfussenegger/nvim-dap',
    dependencies = {
        {
            'rcarriga/nvim-dap-ui',
            dependencies = { 'nvim-neotest/nvim-nio' },
        },
        'theHamsta/nvim-dap-virtual-text',
        {
            'jay-babu/mason-nvim-dap.nvim',
            dependencies = { 'williamboman/mason.nvim' },
        },
    },
    keys = {
        { "<leader>bb", function() require('dap').toggle_breakpoint() end, desc = "[B]reakpoint toggle" },
        { "<leader>bc", function() require('dap').continue() end, desc = "[B]reakpoint continue/start" },
        { "<leader>bi", function() require('dap').step_into() end, desc = "[B]reakpoint step into" },
        { "<leader>bo", function() require('dap').step_over() end, desc = "[B]reakpoint step over" },
        { "<leader>bO", function() require('dap').step_out() end, desc = "[B]reakpoint step out" },
        { "<leader>bt", function() require('dap').terminate() end, desc = "[B]reakpoint terminate" },
        { "<leader>bu", function() require('dapui').toggle() end, desc = "[B]reakpoint UI toggle" },
    },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

        require('mason-nvim-dap').setup({
            ensure_installed = { 'codelldb' },
            automatic_installation = true,
            handlers = {}, -- use default handler for each installed adapter, sets up codelldb automatically
        })

        dapui.setup()
        require('nvim-dap-virtual-text').setup()

        -- Auto open/close the UI alongside the debug session
        dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
        end
    end
}
