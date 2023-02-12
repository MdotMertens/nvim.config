return {
    {
	'TimUntersberger/neogit',
	dependencies = {'nvim-lua/plenary.nvim'},

	config = function()
		require("neogit").setup{}
	end,
	keys = {
	    {"<leader>gs", "<cmd>Neogit<cr>", desc="Find Files"},
	}
    }
}
