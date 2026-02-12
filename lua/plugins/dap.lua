return {
    "mfussenegger/nvim-dap",

    lazy = true,

    dependencies = {
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim", -- adapter for mason to work with debuggers
        "rcarriga/nvim-dap-ui", -- ui for nvim-dap
        "nvim-neotest/nvim-nio", -- required by nvim-dap-ui
        "theHamsta/nvim-dap-virtual-text",
        -- Each language requires its own debug adapter.
        -- On top of that, some languages require a dedicated nvim plugin.
        -- Add debug adapter language plugins below to auto install them.
        -- debug adapters themselves can be installed with Mason for example.
        "leoluz/nvim-dap-go",
        { "mrcjkb/rustaceanvim", version = ">=5", lazy = false },
        "mfussenegger/nvim-dap-python",
    },

    keys = function(_, keys)
        local dap = require("dap")
        local dapui = require("dapui")

        local function smart_continue()
            -- TODO: use event_listeners instead
            -- Only on initialization
            if not dap.session() then
                -- show the UI if it is not visible yet
                local dapwin = require("dapui.windows")
                local any_opened = false
                for _, win in ipairs(dapwin.layouts) do
                    if win:is_open() then any_opened = true end
                end
                if not any_opened then dapui.open() end

                -- Use current line as fallback breakpoint if none is set yet
                local dapbp = require("dap.breakpoints")
                if not next(dapbp.get()) then dapbp.set() end
            end

            -- Start
            dap.continue()
        end

        local function toggle_breakpoint_cond()
            local condition = vim.fn.input("Breakpoint condition: ")
            dap.set_breakpoint(condition)
        end

        local function float_opener(name)
            local opts = { enter = true, position = "center" }
            return function() dapui.float_element(name, opts) end
        end

        return {
            { "<C-n>n", smart_continue, desc = "Debug: Start/Continue" },
            { "<C-n>q", dap.terminate, desc = "Debug: Terminate" },
            { "<C-n>j", dap.step_over, desc = "Debug: Step Over" },
            { "<C-n>k", dap.run_to_cursor, desc = "Debug: Run to cursor" },
            { "<C-n>i", dap.step_into, desc = "Debug: Step Into" },
            { "<C-n>o", dap.step_out, desc = "Debug: Step Out" },
            { "<C-n>U", dap.down, desc = "Debug: Go 1 frame down" },
            { "<C-n>u", dap.up, desc = "Debug: Go 1 frame up" },
            { "<C-n>l", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
            { "<C-n>m", toggle_breakpoint_cond, desc = "Debug: Set Breakpoint condition" },
            { "<C-n>x", dap.set_exception_breakpoints, desc = "Debug: Toggle Exception Breakpoint" },
            { "<C-n>w", dapui.toggle, desc = "Debug: Toggle user interface" },
            { "<C-n>,", float_opener("scopes"), desc = "Debug: Open floating window with scopes" },
            { "<C-n>;", float_opener("breakpoints"), desc = "Debug: Open floating window with breakpoints" },
            { "<C-n>:", float_opener("stacks"), desc = "Debug: Open floating window with stacks" },
            { "<C-n>!", float_opener("watches"), desc = "Debug: Open floating window with watches" },
            { "<C-n>%", float_opener("repl"), desc = "Debug: Open floating window with repl" },
            { "<C-n>*", float_opener("console"), desc = "Debug: Open floating window with console" },
            unpack(keys),
        }
    end,

    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStoppedIcon", linehl = "DapStopped", numhl = "DapStopped" })

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

        require("nvim-dap-virtual-text").setup({
            virt_text_pos = "eol",
        })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        dap.configurations.lua = {
            {
                name = 'Current file (local-lua-dbg, lua)',
                type = 'local-lua',
                request = 'launch',
                cwd = '${workspaceFolder}',
                program = {
                    lua = 'lua5.1',
                    file = '${file}',
                },
                args = {},
            },
        }

        -- TODO: add this command in a dedicated setup
        -- require('dap-go').debug_test()
        require("dap-go").setup({

        })

        -- XXX: This depends on the project...
        require("dap-python").setup("uv")
        dap.configurations.python = {
            {
                name = "DebugPy: Current File",
                type = "debugpy",
                request = "launch",
                program = "${file}",
                console = "integratedTerminal",
                justMyCode = false,
            },
            {
                name = "DebugPy: Module",
                type = "debugpy",
                request = "launch",
                module = function()
                    return "scripts.doc"
                    -- local rel_path = vim.fn.expand("%:.")
                    -- local mod_path = string.gsub(rel_path, "/", ".")
                    -- return mod_path
                end,
                console = "integratedTerminal",
                justMyCode = false,
                -- redirectOutput = true,
            },
            {
                name = "DebugPy: Uvicorn",
                type = "debugpy",
                request = "launch",
                module = "uvicorn",
                args = { "app.main:api" },
                console = "integratedTerminal",
                justMyCode = false,
            },
        }
    end,
}
