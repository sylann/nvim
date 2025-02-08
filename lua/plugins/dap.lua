return {
    "mfussenegger/nvim-dap",

    lazy = true,

    dependencies = {
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim", -- adapter for mason to work with debuggers
        "rcarriga/nvim-dap-ui", -- ui for nvim-dap
        "nvim-neotest/nvim-nio", -- required by nvim-dap-ui
        -- Each language requires its own debug adapter.
        -- On top of that, some languages require a dedicated nvim plugin.
        -- Add debug adapter language plugins below to auto install them.
        -- debug adapters themselves can be installed with Mason for example.
        "leoluz/nvim-dap-go",
        { "mrcjkb/rustaceanvim", version = "^5", lazy = false },
        "mfussenegger/nvim-dap-python",
    },

    keys = function(_, keys)
        local dap = require("dap")
        local dapui = require("dapui")

        local function toggle_breakpoint_cond() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end
        return {
            { "<C-n>m", dap.continue, desc = "Debug: Start/Continue" },
            { "<C-n>l", dap.step_over, desc = "Debug: Step Over" },
            { "<C-n>j", dap.step_into, desc = "Debug: Step Into" },
            { "<C-n>k", dap.step_out, desc = "Debug: Step Out" },
            { "<C-n>b", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
            { "<C-n>B", toggle_breakpoint_cond, desc = "Debug: Set Breakpoint condition" },
            { "<C-n>n", dapui.toggle, desc = "Debug: Toggle user interface" },
            unpack(keys),
        }
    end,

    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup({
            automatic_installation = true,

            -- INFO: see mason-nvim-dap README for more information
            handlers = {},

            ensure_installed = {
                "delve",
                "python",
                "js",
                "firefox",
                "stylua",
                "codelldb",
                "bash",
            },
        })

        dapui.setup()

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        require("dap-go").setup()

        -- XXX: This depends on the project...
        require("dap-python").setup("uv")
        table.insert(dap.configurations.python, {
            name = "Python Debugger: Module",
            type = "debugpy",
            request = "launch",
            module = "debug.distinct_on",
            justMyCode = false,
            redirectOutput = true,
        })
    end,
}
