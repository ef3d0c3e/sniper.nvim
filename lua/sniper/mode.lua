local M = {}

-- Whether sniper mode is active
M.jump_mode_active = false
-- Buffer for number command
M.count_buffer = ""
-- Current jump marks
M.marks = {}

-- Highlight content in buffer
local function set_inline_virtual_text(sniper, row, col, hl, text)
	vim.api.nvim_buf_set_extmark(0, sniper.ns_id, row, col, {
		virt_text = { { text, hl } },
		virt_text_pos = "overlay",
	})
end

-- Function to exit sniper mode
local function quit_sniper_mode(sniper)
	M.jump_mode_active = false
	M.count_buffer = ""
	vim.on_key(nil, vim.api.nvim_get_current_win()) -- remove handler
	vim.api.nvim_buf_clear_namespace(0, sniper.ns_id, 0, -1)
end

-- Sniper mode
local function sniper_mode_callback(sniper)
	return function(key)
		if not M.jump_mode_active then return end

		if key:match("%d") then
			-- accumulate number keys for count
			M.count_buffer = M.count_buffer .. key
			return "" -- block from normal processing
		elseif key == vim.api.nvim_replace_termcodes("<Esc>", true, true, true) then
			quit_sniper_mode(sniper)
			return ""
		else
			local count = tonumber(M.count_buffer) or 1
			M.count_buffer = ""

			local id = tostring(key) or nil
			if id then
				local mark = M.marks[id]
				if mark and mark[count] then
					local row, col = mark[count][1], mark[count][2]
					vim.api.nvim_win_set_cursor(0, { row + 1, col })
				end
			end
			quit_sniper_mode(sniper)
			return ""
		end
	end
end

-- Enter sniper mode and start highlighting
function M.sniper_mode_enter(sniper)
	M.marks = {}
	M.marks[sniper.config.marks.paren.key[1]] = {}
	M.marks[sniper.config.marks.paren.key[2]] = {}

	for key, mark in pairs(sniper.config.marks) do
		local hi = string.format("Sniper_%s", key)
		M.marks[mark.key[1]] = {}
		M.marks[mark.key[2]] = {}

		local before, after = sniper.match.find_symbols(mark.symbols, 9, 9)
		for k, v in ipairs(after) do
			M.marks[mark.key[1]][k] = v
			set_inline_virtual_text(sniper, v[1], v[2], hi, string.format("%d", k))

		end
		for k, v in ipairs(before) do
			M.marks[mark.key[2]][k] = v
			set_inline_virtual_text(sniper, v[1], v[2], hi, string.format("%d", k))
		end
	end

	M.jump_mode_active = true
	vim.on_key(sniper_mode_callback(sniper), vim.api.nvim_get_current_win())
end

return M
