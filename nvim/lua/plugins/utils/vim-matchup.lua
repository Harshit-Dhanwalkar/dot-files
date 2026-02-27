-- ~/.config/nvim/lua/plugins/utils/vim-matchup.lua
--:hi MatchParen ctermbg=blue guibg=lightblue cterm=italic gui=italic
--:hi MatchParenCur cterm=underline gui=underline
-- :hi MatchWordCur cterm=underline gui=underline
return {
	"andymass/vim-matchup",
	init = function()
		require("match-up").setup({
			treesitter = {
				stopline = 500,
			},
		})
	end,
}
