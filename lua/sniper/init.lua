local M = {}

M.ns_id = vim.api.nvim_create_namespace("sniper")

M.config = {
	marks = {}
}

function M.setup(opts)
	if opts then
		M.config = vim.tbl_deep_extend("force", M.config, opts)
	end
	M.match = require("sniper.match")
	M.mode = require("sniper.mode")

	for key, mark in pairs(M.config.marks) do
		local hi = string.format("Sniper_%s", key)
		vim.api.nvim_set_hl(0, hi, mark.hi)
	end

	vim.api.nvim_create_user_command("SniperEnter", function ()
		M.mode.sniper_mode_enter(M)
	end, {})

	--vim.keymap.set("n", "w", function ()
	--	M.mode.sniper_mode_enter(M)
	--end)
	--vim.keymap.set("n", "W", function ()
	--	M.mode.sniper_mode_enter(M)
	--end)
end

return M
