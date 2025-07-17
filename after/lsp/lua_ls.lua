-- INFO: I only use Lua for my Neovim configuration at the moment.
-- The Lazydev plugin provides a great configuration for this use case.
-- Hence, several settings are ommited here on purpose, to let Lazydev do the job.

-- See settings schema here:
-- https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            telemetry = {
                enable = false,
            },
            completion = {
                callSnippet = "Replace",
            },
        },
    },
}
