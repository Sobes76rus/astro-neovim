local lsp_util = require('lspconfig.util')
local utils = require('user.utils')

return function(opts)
  local p

  if vim.env.VIRTUAL_ENV then
    p = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
  else
    p = utils.find_cmd("python3", ".venv/bin", opts.root_dir)
  end

  opts.settings = {
    python = {
      pythonPath = p,
      analysis = {
        stubPath = 'stubs'
      }
    }
  }

  return opts
end
