local h = require "null-ls.helpers"
local methods = require "null-ls.methods"
local u = require "null-ls.utils"

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local overrides = {
  severities = {
    error = h.diagnostics.severities["error"],
    warning = h.diagnostics.severities["warning"],
    note = h.diagnostics.severities["information"],
  },
}

return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"
    local utils = require "user.utils"

    -- config.debug = true

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.black,
      -- Set a Linter
      null_ls.builtins.diagnostics.mypy.with {
        generator_opts = {
          command = function(params) return utils.find_cmd("mypy", ".venv/bin", params.root) end,
          args = function(params)
            return {
              "--hide-error-codes",
              "--hide-error-context",
              "--no-color-output",
              "--show-absolute-path",
              "--show-column-numbers",
              "--show-error-codes",
              "--no-error-summary",
              "--no-pretty",
              "--shadow-file",
              params.bufname,
              params.temp_path,
              params.bufname,
            }
          end,
          to_temp_file = true,
          format = "line",
          check_exit_code = function(code) return code <= 2 end,
          multiple_files = true,
          ignore_stderr = true,
          on_output = h.diagnostics.from_patterns {
            -- see spec for pattern examples
            {
              pattern = "([^:]+):(%d+):(%d+): (%a+): (.*)  %[([%a-]+)%]",
              groups = { "filename", "row", "col", "severity", "message", "code" },
              overrides = overrides,
            },
            -- no error code
            {
              pattern = "([^:]+):(%d+):(%d+): (%a+): (.*)",
              groups = { "filename", "row", "col", "severity", "message" },
              overrides = overrides,
            },
            -- no column or error code
            {
              pattern = "([^:]+):(%d+): (%a+): (.*)",
              groups = { "filename", "row", "severity", "message" },
              overrides = overrides,
            },
          },
          cwd = h.cache.by_bufnr(function(params)
            return u.root_pattern(
              -- https://mypy.readthedocs.io/en/stable/config_file.html
              "mypy.ini",
              ".mypy.ini",
              "pyproject.toml",
              "setup.cfg"
            )(params.bufname)
          end),
        },
      },
    }

    return config -- return final config table
  end,
}
