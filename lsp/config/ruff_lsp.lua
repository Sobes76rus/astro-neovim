local lsp_util = require "lspconfig.util"
local utils = require "user.utils"

return function(opts)
  local p
  local r

  if vim.env.VIRTUAL_ENV then
    p = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    r = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "ruff")
  else
    p = utils.find_cmd("python", ".venv/bin", opts.root_dir)
    r = utils.find_cmd("ruff", ".venv/bin", opts.root_dir)
  end

  opts.init_options = {
    settings = {
      interpreter = { p },
      args = {
        "--extend-select",
        "I",
      },
    },
  }

  opts.on_attach = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.py", "*.pyi" },
      callback = function()
        local clients = vim.lsp.get_active_clients()
        for _, client in pairs(clients) do
          if client.name ~= "ruff_lsp" then goto continue end

          local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
          params.context = {
            only = { "source.organizeImports" },
            diagnostics = {},
          }

          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
              else
                vim.lsp.buf.execute_command(r.command)
              end
            end
          end

          ::continue::
        end
      end,
    })
  end

  return opts
end
