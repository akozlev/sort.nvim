local buffer = require('sort.buffer')
local command = require('sort.command')
local config = require('sort.config')
local selection = require('sort.selection')
local sort = require('sort.sort')

local M = {}

--- Sort by either lines or specified delimiters, depending on the selection.
--- @param sel Selection
--- @param options SortOptions
local line_or_delimiter_sort = function(sel, options)
  selection.sanitise(sel)

  local is_multiple_lines_selected = sel.start.row < sel.stop.row

  if is_multiple_lines_selected then
    sort.line_sort(sel, options)
  else
    local text = buffer.get_text_in_selection(sel)[1]
    local sorted_text = sort.delimiter_sort(text, options)
    buffer.set_text_in_selection(sel, { sorted_text })
  end
end

--- Parse bang and arguments, determine the selection and and delegate the sorting to the API.
--- @param bang string
--- @param arguments string
M.command = function(bang, arguments)
  local options = command.read_arguments(bang, arguments)
  local sel = selection.from_marks('<', '>')
  line_or_delimiter_sort(sel, options)
end

--- Sort operator with respect to the provided options.
--- @param options SortOptions
M.operator = function(options)
  local oldfunc = vim.opt.operatorfunc
  local opts = options or {}

  _G._sort_operatorfunc = function(motion)
    local sel = selection.from_motion(motion)
    line_or_delimiter_sort(sel, opts)
    vim.opt.operatorfunc = oldfunc
    _G._sort_operatorfunc = nil
  end

  vim.opt.operatorfunc = 'v:lua._sort_operatorfunc'
  return 'g@'
end

M.setup = config.setup

return M
