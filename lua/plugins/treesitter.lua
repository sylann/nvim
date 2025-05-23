return {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",

    build = ":TSUpdate",

    opts = {
        -- stylua: ignore
        ensure_installed = {
            -- Required parsers (should always be installed)
            "c", "lua", "vim", "vimdoc", "query",
            ------------------------------------------------
            "rust", "go", "cpp",
            "sql", "http",
            "bash", "python", -- "ruby", "perl",
            "php", "blade", "php_only",
            "dockerfile", "make",
            "json", "jsonc", "toml", "yaml", "markdown",
            "html", "css", "javascript", "jsdoc", "typescript", "vue",
            "angular",
            "diff", "git_rebase", "git_config",
        },

        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},

        highlight = {
            enable = true,

            disable = function(lang, buf)
                -- Language
                local disabled_languages = {"csv", "tsv", "rfc_csv"}
                if vim.list_contains(disabled_languages, lang) then return true end

                -- Size
                local max_filesize = 1024 * 250 -- 250 kb
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then return true end
            end,

            --  INFO: add languages for which treesitter base highlight is lacking
            additional_vim_regex_highlighting = {
                -- "Dockerfile",
                "markdown",
                "sql",
                "terraform-vars",
                "angular",
            },
        },

        indent = {
            enable = true,
        },
    },

    config = function(_, opts)
        -- INFO: `:help nvim-treesitter`
        -- INFO: `:help nvim-treesitter-incremental-selection-mod`
        -- INFO: https://github.com/nvim-treesitter/nvim-treesitter-context
        -- INFO: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.blade = {
            install_info = {
                url = "https://github.com/EmranMR/tree-sitter-blade",
                files = { "src/parser.c" },
                branch = "main",
            },
            filetype = "blade",
        }

        require("nvim-treesitter.configs").setup(opts)

        vim.filetype.add({
            extension = {
                conf = "conf",
                env = "sh",
                tf = "terraform",
                -- tfstate = "terraform",
                har = "json",
            },
            filename = {
                [".env.example"] = "sh",
                ["env"] = "sh",
                ["tsconfig.json"] = "jsonc",
                ["settings.json"] = "jsonc",
                ["sylfire-dark.json"] = "jsonc",
                ["sylfire-light.json"] = "jsonc",
                [".flake8"] = "ini",
                [".yamlfmt"] = "yaml",
            },
            -- See: https://neovim.io/doc/user/luaref.html#lua-patterns
            pattern = {
                [".*%.component%.html"] = "htmlangular",
                -- ["[%w_.-]+%.env%"] = "sh",
            },
        })
    end,
}
