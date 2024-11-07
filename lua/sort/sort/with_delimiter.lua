local config = require('sort.config')

--- Parse numbers from string.
--- @param text string
--- @param base? integer
--- @return integer | nil
local parse_number = function(text, base)
  base = base or 10
  local match

  if base == 2 then
    match = string.match(text, '%d+')
  elseif base == 10 then
    match = string.match(text, '%-?[%d.]+')
  elseif base == 16 then
    local minus, hexMatch

    minus, hexMatch = string.match(text, '(%-?)0[xX](%x+)')
    if minus == nil then
      minus, hexMatch = string.match(text, '(%-?)(%x+)')
    end

    match = (minus or '') .. (hexMatch or '')
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  return tonumber(match or '', base ~= 10 and base or nil)
end

--- Constructs a comparator based on the provided options.
--- @param options SortOptions
--- @return fun(any, any): boolean
local comparator = function(options)
  return function(a, b)
    a = options.ignore_case and string.lower(a) or a
    b = options.ignore_case and string.lower(b) or b

    if options.numerical then
      local na = parse_number(a, options.numerical)
      local nb = parse_number(b, options.numerical)

      if na and nb then
        return na < nb
      elseif na then
        return false
      elseif nb then
        return true
      end
    end

    return a < b
  end
end

--- Remove dupliactes from a sorted list in-place.
--- @param list any[]
local remove_duplicates = function(list)
  local last_item
  for idx, item in ipairs(list) do
    if item == last_item then
      table.remove(list, idx)
    else
      last_item = item
    end
  end
end

--- Reverse the list in-place.
--- @param list any[]
local reverse = function(list)
  local size = #list
  for i = 1, math.floor(size / 2) do
    list[i], list[size - i] = list[size - i], list[i]
  end
end

--- Translate delimiter values to proper characters.
--- @param delimiter string
--- @return string translated_delimiter
local translate_delimiter = function(delimiter)
  local translateMap = {
    t = '\t',
    s = ' ',
  }

  return translateMap[delimiter] or delimiter
end

--- Sort by the first applicable delimiter.
--- @param text string
--- @param options SortOptions
--- @return string sorted_text
local sort_with_delimiter = function(text, options)
  local user_config = config.get_user_config()
  local delimiters = options.delimiter and { options.delimiter }
    or user_config.delimiters

  local delimiter, words, has_delimiter
  for _, d in ipairs(delimiters) do
    delimiter = translate_delimiter(d)
    words = vim.split(text, delimiter)
    has_delimiter = #words > 1
    if has_delimiter then
      break
    end
  end

  if has_delimiter then
    return text
  end

  table.sort(words, comparator(options))

  if options.unique then
    remove_duplicates(words)
  end

  if options.reverse then
    reverse(words)
  end

  local has_leading_delimiter = string.match(text, '^' .. delimiter)
  local has_trailing_delimiter = string.match(text, delimiter .. '$')

  return (has_leading_delimiter and delimiter or '')
    .. table.concat(words, delimiter)
    .. (has_trailing_delimiter and delimiter or '')
end

return sort_with_delimiter
