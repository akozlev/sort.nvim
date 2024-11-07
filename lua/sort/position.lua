local M = {}

--- @class Position
--- @field public row integer
--- @field public column integer
--- both indices are one-based and inclusive.

--- Get the position of the given buffer mark.
--- @param mark string
--- @return Position
M.of_mark = function(mark)
  local row, column = unpack(vim.api.nvim_buf_get_mark(0, mark))
  return {
    -- `nvim_buf_get_mark()` is (1,0)-based but `Position` is (1,1)-based
    row = row,
    column = column + 1,
  }
end

--- Clamp out-bound indices in-place to the nearest valid index.
--- @param position Position
M.sanitise = function(position)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

  position.row = math.max(position.row, 1)
  position.row = math.min(position.row, #lines)

  local length_of_row = #lines[position.row]

  position.column = math.max(position.column, 1)
  position.column = math.min(position.column, length_of_row)
end

--- String representation of the position.
--- @param position Position
--- @return string
M.tostring = function(position)
  return 'Position ' .. position.row .. ':' .. position.column
end

return M
