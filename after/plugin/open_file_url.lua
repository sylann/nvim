local function parse_url_params(url)
    url = vim.trim(url)
    local values = vim.split(vim.split(url, '?')[2], '&') -- XXX: will have to do that more properly at some point

    local params = {}
    for _, value in ipairs(values) do
        local kv = vim.split(value, '=')
        params[kv[1]] = kv[2]
    end
    return params
end

local function open_file_from_uri(url)
    local params = parse_url_params(url)
    if not params.file or not params.line then
        vim.notify(string.format("Impossible to parse url: '%s'", url), vim.log.levels.ERROR)
        return
    end
    local path = vim.uri_decode(params.file)
    local line = params.line

    vim.cmd(string.format("edit +%d %s", line, path))
end

local function open_file_from_clipboard()
    local url = vim.fn.input("url: ")
    if url then open_file_from_uri(url) end
end

vim.api.nvim_create_user_command("OpenFileFromUri", open_file_from_clipboard, { desc = "Open a file at line according to the uri in the system clipboard" })
