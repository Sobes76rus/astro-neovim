local M = {}

M.find_cmd = function(cmd, prefixes, start_from, stop_at)
  local util = require "null-ls.utils"

  if start_from == nil then start_from = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) end

  if prefixes == nil then
    prefixes = { "." }
  elseif type(prefixes) == "string" then
    prefixes = { prefixes }
  end

  for _, dir in
    ipairs(vim.fs.find(prefixes, {
      upward = true,
      limit = 1,
      path = start_from,
      type = "directory",
    }))
  do
    local maybe_executable = util.path.join(dir, cmd)
    if util.is_executable(maybe_executable) then return maybe_executable end
  end

  return cmd
end

return M
