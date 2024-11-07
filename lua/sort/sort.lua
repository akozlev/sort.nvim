local command = require('sort.command')

local M = {}

--- @class SortOptions
--- @field public delimiter? string
--- @field public ignore_case boolean
--- @field public numerical? integer
--- @field public reverse boolean
--- @field public unique boolean

M.delimiter_sort = require('sort.sort.with_delimiter')

--- Sort by line, using the default :sort.
--- @param selection Selection
--- @param options SortOptions
M.line_sort = function(selection, options)
  local bang, arguments = command.write_arguments(options)
  local range = tostring(selection.start.row)
    .. ','
    .. tostring(selection.stop.row)
  vim.api.nvim_command(range .. 'sort' .. bang .. ' ' .. arguments)
end

return M
