local M = {}

--- Parse options provided via bang and/or arguments.
--- @param bang string
--- @param arguments string
--- @return SortOptions options
M.read_arguments = function(bang, arguments)
  local delimiterPattern = '[st%p]'
  local numericalPattern = '[bnox]'

  local delimiter = string.match(arguments, delimiterPattern)
  local numerical
  for match in string.gmatch(arguments, numericalPattern) do
    if match == 'b' then
      numerical = 2
    elseif match == 'o' then
      numerical = 8
    elseif match == 'x' then
      numerical = 16
    else
      numerical = 10
    end

    break
  end

  return {
    delimiter = delimiter,
    ignore_case = string.match(arguments, 'i') == 'i',
    numerical = numerical,
    reverse = bang == '!',
    unique = string.match(arguments, 'u') == 'u',
  }
end

--- Serialize the provided options to bang and arguments.
--- @param options SortOptions
--- @return string bang
--- @return string arguments
M.write_arguments = function(options)
  local bang = options.reverse and '!' or ''
  local delimiter = options.delimiter or ''
  local ignore_case = options.ignore_case and 'i' or ''
  local unique = options.unique and 'u' or ''

  local numerical
  if options.numerical == 2 then
    numerical = 'b'
  elseif options.numerical == 8 then
    numerical = 'o'
  elseif options.numerical == 16 then
    numerical = 'x'
  else
    numerical = ''
  end

  local arguments = delimiter .. ignore_case .. numerical .. unique

  return bang, arguments
end

return M
