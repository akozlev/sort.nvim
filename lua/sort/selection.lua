local M = {}

local position = require('sort.position')

--- @class Selection
--- @field public start Position
--- @field public stop Position

--- The selection defined by the given marks.
--- @param mark1 string
--- @param mark2 string
--- @return Selection
M.from_marks = function(mark1, mark2)
  local selection = {
    start = position.of_mark(mark1),
    stop = position.of_mark(mark2),
  }

  M.sanitise(selection)

  return selection
end

--- The selection defined by the performed motion.
--- @param motion string
--- @return Selection
M.from_motion = function(motion)
  local selection = M.from_marks('[', ']')

  if motion == 'line' then
    -- linewise motions set the `] in the first instead of the last column
    local stop_line = unpack(
      vim.api.nvim_buf_get_lines(
        0,
        selection.stop.row - 1,
        selection.stop.row,
        true
      )
    )
    selection.stop.column = #stop_line
  end

  return selection
end

--- If the selection is inversed, reverse it in-place.
--- @param selection Selection
M.reverse_if_inversed = function(selection)
  local is_inversed = selection.start.row > selection.stop.row
    or (
      selection.start.row == selection.stop.row
      and selection.start.column >= selection.stop.column
    )

  if is_inversed then
    selection.start, selection.stop = selection.stop, selection.start
  end
end

--- Sanitise the selection in-place.
--- @param selection Selection
M.sanitise = function(selection)
  M.reverse_if_inversed(selection)
  position.sanitise(selection.start)
  position.sanitise(selection.stop)
end

--- String representation of the selection.
--- @param selection Selection
--- @return string
M.tostring = function(selection)
  return 'Selection { start: '
    .. position.tostring(selection.start)
    .. ', stop: '
    .. position.tostring(selection.stop)
    .. ' }'
end

return M
