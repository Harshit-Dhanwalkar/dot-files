return {
	"vim-pandoc/vim-markdownfootnotes",
	ft = "markdown",
	config = function()
		require("render-markdown").setup({
			-- Options:
			-- -- arabic: 1, 2, 3...
			-- -- alpha: a, b, c, aa, bb..., zz, a...
			-- -- Alpha: A, B, C, AA, BB..., ZZ, A...
			-- -- roman: i, ii, iii... (displayed properly up to 89)
			-- -- Roman: I, II, III...
			-- -- star: *, **, ***...
			vimfootnotetype = "arabic",
			-- Disable line breaks before each footnote
			-- vimfootnotelinebreak = 0,
		})
	end,
}
