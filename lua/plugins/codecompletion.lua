return {
	{ "williamboman/mason.nvim", config = function() require("mason").setup {} end, cmd = "Mason" },
	{
		'nvim-treesitter/nvim-treesitter',
		config = function()
			require 'nvim-treesitter.configs'.setup {
				sync_install = false,
				auto_install = true,
				ignore_install = { "javascript" },
				highlight = {
					enable = true
				}
			}
		end
	},
	{
	    "github/copilot.vim",
	},
	{ 'hrsh7th/nvim-cmp',
		dependencies = { "L3MON4D3/LuaSnip" },
		event = "InsertEnter",
		config = function()
			local cmp = require "cmp"
			local luasnip = require("luasnip")
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			cmp.setup({
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					-- ... Your other mappings ...
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				})
			})
		end, },
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			'hrsh7th/cmp-nvim-lsp',
			"jose-elias-alvarez/null-ls.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-null-ls").setup({ automatic_setup = true, })
			require('mason-null-ls').setup_handlers()
			require('null-ls').setup()
			vim.diagnostic.config({
				virtual_text = false,
			})

			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			require("lspconfig").pyright.setup { capabilities = capabilities }
			require("lspconfig").sumneko_lua.setup { capabilities = capabilities }
		end,
		lazy = false,
		keys = {
			{ "<leader>fr", function() vim.lsp.buf.format { async = true } end, desc = "Format Files" },
		}
	},
	{
		"glepnir/lspsaga.nvim",
		event = "BufRead",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
		keys = {
			{ "<leader>fi", "<cmd>Lspsaga lsp_finder<cr>", desc = "Format Files" },
			{ "<leader>gD", "<cmd>Lspsaga goto_definition<cr>", desc = "Format Files" },
			{ "<leader>gd", "<cmd>Lspsaga peek_definition<cr>", desc = "Format Files" },
			{ "<leader>sd", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Format Files" },
			{ "[e", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Format Files" },
			{ "]e", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Format Files" },
			{ "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Format Files" },
			{ "<leader>rn", "<cmd>Lspsaga rename ++project<cr>", desc = "Format Files" },
		}
	}
}
