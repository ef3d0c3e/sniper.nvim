local M = {}

--- Find symbol forward/backward by count
--- @param matches string[] Array containing strings to match
--- @param before integer Number of wanted before matches
--- @param after integer Number of wanted after matches
--- @return table, table
function M.find_symbols(matches, before, after)
    if not matches or #matches == 0 then
        error("find_symbols: matches table cannot be empty")
    end
    before = before or 0
    after  = after  or 0

    local cursor = vim.api.nvim_win_get_cursor(0)
    local crow, ccol = cursor[1] - 1, cursor[2]

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local before_matches = {}
    local after_matches  = {}

	-- Backward search
    if before > 0 then
        local found = 0
        for r = crow, 0, -1 do
            local line = lines[r + 1] or ""
            local start_c = (r == crow) and (ccol - 1) or (#line - 1)
            local c = start_c
            while c >= 0 do
                for _, s in ipairs(matches) do
                    local len = #s
                    if len > 0 then
                        local start_idx = c - len + 1
                        if start_idx >= 0 then
                            local end_idx = start_idx + len - 1
                            if not (r == crow and end_idx >= ccol) then
                                if line:sub(start_idx + 1, start_idx + len) == s then
                                    table.insert(before_matches, { r, start_idx })
                                    found = found + 1
                                    break
                                end
                            end
                        end
                    end
                end
                if found >= before then break end
                c = c - 1
            end
            if found >= before then break end
        end
    end

	-- Forward search
    if after > 0 then
        local found = 0
        for r = crow, #lines - 1 do
            local line = lines[r + 1] or ""
            local start_c = (r == crow) and (ccol + 1) or 0
            local c = start_c
            local linelen = #line
            while c <= linelen - 1 do
                for _, s in ipairs(matches) do
                    local len = #s
                    if len > 0 and (c + len - 1) <= (linelen - 1) then
                        if not (r == crow and c <= ccol) then
                            if line:sub(c + 1, c + len) == s then
                                table.insert(after_matches, { r, c })
                                found = found + 1
                                break
                            end
                        end
                    end
                end
                if found >= after then break end
                c = c + 1
            end
            if found >= after then break end
        end
    end

    return before_matches, after_matches
end

return M
