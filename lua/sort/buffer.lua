local M = {}

--- Get text enclosed by the given selection.
--- @param selection Selection
--- @return string[]
M.get_text_in_selection = function(selection)
  return vim.api.nvim_buf_get_text(
    0,
    selection.start.row - 1,
    selection.start.column - 1,
    selection.stop.row - 1,
    selection.stop.column,
    {}
  )
end

--- Set text enclosed by the given selection.
--- @param selection Selection
--- @param text string[]
M.set_text_in_selection = function(selection, text)
  vim.api.nvim_buf_set_text(
    0,
    selection.start.row - 1,
    selection.start.column - 1,
    selection.stop.row - 1,
    selection.stop.column,
    text
  )
end

return M
