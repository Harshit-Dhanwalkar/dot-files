# import subprocess

c = c
config = config

colors = {
    "*color0": "#111111",  # A dark background for contrast
    "*color1": "#FF7F52",  # A dark background for contrast
    "*color7": "#2F26F0",
    "*color8": "#3A2A5A",
    "*color12": "#61AFEF",
    "*color13": "#000000",
    "*color14": "#4F3A64",
    "*.background": "#00000000",  # Fallback background
    "*.foreground": "#000A34",  # Fallback foreground
}

# statusbar
c.statusbar.show = "always"
c.colors.statusbar.normal.bg = "#00000000"
c.colors.statusbar.command.bg = "#00000000"
c.colors.statusbar.command.fg = colors["*color7"]
c.colors.statusbar.normal.fg = colors["*color14"]
c.colors.statusbar.passthrough.fg = colors["*color14"]
c.colors.statusbar.url.fg = colors["*color13"]
c.colors.statusbar.url.success.https.fg = colors["*color13"]
c.colors.statusbar.url.hover.fg = colors["*color12"]

# tabs
c.colors.tabs.even.bg = "#00000000"  # transparent tabs
c.colors.tabs.odd.bg = "#00000000"
c.colors.tabs.bar.bg = "#00000000"
c.colors.tabs.even.fg = colors["*color0"]
c.colors.tabs.odd.fg = colors["*color13"]
c.colors.tabs.selected.even.bg = colors["*.background"]
c.colors.tabs.selected.odd.bg = colors["*.background"]
c.colors.tabs.indicator.start = colors["*color8"]
c.colors.tabs.indicator.stop = colors["*color7"]

# hints
# c.colors.hints.bg = "#000"
c.colors.hints.fg = "#4F4F1D"
c.hints.border = "#F8FC50"

# completion
# c.colors.completion.item.selected.match.fg = colors["*color6"]
# c.colors.completion.match.fg = colors["*color6"]
c.colors.completion.odd.bg = colors["*color0"]
c.colors.completion.even.bg = colors["*color1"]
# c.colors.completion.fg = colors["*.foreground"]
# c.colors.completion.category.bg = colors["*.background"]
# c.colors.completion.category.fg = colors["*.foreground"]
# c.colors.completion.item.selected.bg = colors["*.background"]
# c.colors.completion.item.selected.fg = colors["*.foreground"]

# messages
# c.colors.messages.info.bg = colors["*.background"]
# c.colors.messages.info.fg = colors["*.foreground"]
# c.colors.messages.error.bg = colors["*.background"]
# c.colors.messages.error.fg = colors["*.foreground"]
# c.colors.downloads.error.bg = colors["*.background"]
# c.colors.downloads.error.fg = colors["*.foreground"]

# c.colors.downloads.bar.bg = colors["*.background"]
# c.colors.downloads.start.bg = colors["*.color10"]
# c.colors.downloads.start.fg = colors["*.foreground"]
# c.colors.downloads.stop.bg = colors["*.color8"]
# c.colors.downloads.stop.fg = colors["*.foreground"]

# c.colors.tooltip.bg = colors["*.background"]
# c.colors.webpage.bg = colors["*.background"]

# c.url.start_pages = ""
# c.url.default_page = ""

c.tabs.title.format = "{audio}{index}:{current_title}"
# c.tabs.title.format = "{audio}{index}: {host}"
c.tabs.position = "left"  # right
c.fonts.web.size.default = 16
c.tabs.show = "multiple"
c.tabs.width = "15%"

c.url.searchengines = {
    # note - if you use duckduckgo, you can make
    # use of its built in bangs, of which there are many!
    # https://duckduckgo.com/bangs
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "!aw": "https://wiki.archlinux.org/?search={}",
    "!apkg": "https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=",
    "!gh": "https://github.com/search?o=desc&q={}&s=stars",
    "!yt": "https://www.youtube.com/results?search_query={}",
}

c.completion.open_categories = [
    "searchengines",
    "quickmarks",
    "bookmarks",
    "history",
    "filesystem",
]

config.load_autoconfig()  # load settings done via the gui

c.auto_save.session = True  # save tabs on quit/restart

# keybinding changes
config.bind("=", "cmd-set-text -s :open")
config.bind("h", "history")
config.bind("cc", 'hint images spawn sh -c "cliphist link {hint-url}"')
config.bind("cs", "cmd-set-text -s :config-source")
config.bind("tH", "config-cycle tabs.show multiple never")
config.bind("sH", "config-cycle statusbar.show always never")
config.bind("T", "hint links tab")
config.bind("pP", "open -- {primary}")
config.bind("pp", "open -- {clipboard}")
config.bind("pt", "open -t -- {clipboard}")
config.bind("qm", "macro-record")
config.bind("<ctrl-y>", "spawn --userscript ytdl.sh")
config.bind("tT", "config-cycle tabs.position top left")
config.bind("gJ", "tab-move +")
config.bind("gK", "tab-move -")
config.bind("gm", "tab-move")
config.bind("r", "reload")

# dark mode setup
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.images = "never"
# config.set("colors.webpage.darkmode.enabled", False, "file://*")

# styles, cosmetics
# c.content.user_stylesheets = ["~/.config/qutebrowser/styles/youtube-tweaks.css"]
c.tabs.padding = {"top": 5, "bottom": 5, "left": 9, "right": 9}
c.tabs.indicator.width = 0  # no tab indicators
# c.window.transparent = True # apparently not needed
c.tabs.width = "12%"

# fonts
c.fonts.default_family = []
c.fonts.default_size = "13pt"
c.fonts.web.family.fixed = "monospace"
c.fonts.web.family.sans_serif = "monospace"
c.fonts.web.family.serif = "monospace"
c.fonts.web.family.standard = "monospace"

# privacy - adjust these settings based on your preference
# config.set("completion.cmd_history_max_items", 0)
# config.set("content.private_browsing", True)
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)
# config.set("content.javascript.enabled", False) # tsh keybind to toggle

# Adblocking info -->
# For yt ads: place the greasemonkey script yt-ads.js in your greasemonkey folder (~/.config/qutebrowser/greasemonkey).
# The script skips through the entire ad, so all you have to do is click the skip button.
# Yeah it's not ublock origin, but if you want a minimal browser, this is a solution for the tradeoff.
# You can also watch yt vids directly in mpv, see qutebrowser FAQ for how to do that.
# If you want additional blocklists, you can get the python-adblock package, or you can uncomment the ublock lists here.
c.content.blocking.enabled = True
# c.content.blocking.method = 'adblock' # uncomment this if you install python-adblock
# c.content.blocking.adblock.lists = [
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
#         "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"]
