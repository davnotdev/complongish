-- complongish --

function get_working_word()
  local mode = vim.api.nvim_get_mode().mode

  if mode ~= "i" then
    return nil
  end

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor_pos[1] - 1
  local col_num = cursor_pos[2]

  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_buf_get_lines(buf, line_num, line_num + 1, false)[1]

  local before_cursor = line:sub(1, col_num)
  
  local word = before_cursor:match("([%w_-]+)$")

  return word
end

local function complongish()
  local word_to_complete = get_working_word()

  if not word_to_complete then
    return
  end

  local buf = vim.api.nvim_get_current_buf()

  local topline = vim.fn.line('w0')
  local botline = vim.fn.line('w$')

  local lines = vim.api.nvim_buf_get_lines(buf, topline - 1, botline, false)
  local visible_text = table.concat(lines, "\n")

  local common_prefix_found = nil
  
  local prefix = nil
  for match in visible_text:gmatch(word_to_complete .. "[%w_-]*") do
    if prefix == nil then
      prefix = match

    else
      local i = 1;
      while i < match:len() do
        if prefix:sub(1, i) ~= match:sub(1, i) then
          prefix = prefix:sub(1, i - 1)
        end
        i = i + 1
      end
    end
  end

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor_pos[1] - 1
  local col_num = cursor_pos[2]

  local current_line = vim.api.nvim_buf_get_lines(buf, line_num, line_num + 1, false)[1]

  local new_line = current_line:sub(1, col_num - #word_to_complete) .. prefix

  vim.api.nvim_buf_set_lines(buf, line_num, line_num + 1, false, {new_line})
  
  vim.api.nvim_win_set_cursor(0, {line_num + 1, col_num + #prefix})
end

-- TODO --

return {
    complongish
}
