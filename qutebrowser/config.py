# import subprocess

import os

c = c
config = config

qt_path = os.path.expanduser("~/.config/qutebrowser")
script_path = os.path.expanduser("~/.config/qutebrowser/scripts/img_dl.sh")

download_dir = "~/Downloads/QuteBrowser-downloads"
download_dir = os.path.expanduser(download_dir)
if not os.path.exists(download_dir):
    os.makedirs(download_dir)
term = "/usr/local/bin/st"
editor = "/home/linuxbrew/.linuxbrew/bin/nvim"
c.editor.command = [term, "-e", editor, "{}"]

palette = {
    "background": "#282c34",  # gray
    "foreground": "#dfdfdf",  # white
    "black": "#181920",
    "dark-gray": "#21242b",
    "gray": "#282c34",
    "cool-gray": "#3b404d",
    "medium-gray": "#3f444a",
    "light-gray": "#5b6268",
    "lighter-gray": "#73797e",
    "pale-gray": "#9ca0a4",
    "white": "#dfdfdf",
    "bright-white": "#fefefe",
    "pure-white": "#ffffff",
    "darker-purple": "#5b3766",
    "dark-purple": "#615c80",
    "purple": "#a9a1e1",
    "dark-pink": "#945aa6",
    "pink": "#c678dd",
    "dark-blue": "#2257a0",
    "blue": "#51afef",
    "light-blue": "#7bb6e2",
    "cyan": "#46d9ff",
    "dark-green": "#668044",
    "green": "#98be65",
    "teal": "#4db5bd",
    "red": "#ff6c6b",
    "orange": "#da8548",
    "yellow": "#ecbe7b",
}

# Background color of the completion widget category headers.
c.colors.completion.category.bg = palette["cool-gray"]
# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = palette["dark-gray"]
# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = palette["dark-gray"]
# Foreground color of completion widget category headers.
c.colors.completion.category.fg = palette["blue"]
# Background color of the completion widget for even rows.
c.colors.completion.even.bg = palette["background"]
# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = palette["dark-gray"]
# Text color of the completion widget.
c.colors.completion.fg = palette["foreground"]
# Background color of the selected completion item.
c.colors.completion.item.selected.bg = palette["medium-gray"]
# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = palette["medium-gray"]
# Top border color of the completion widget category headers.
c.colors.completion.item.selected.border.top = palette["medium-gray"]
# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = palette["foreground"]
# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = palette["pink"]
# Foreground color of the selected matched text in the completion.
c.colors.completion.item.selected.match.fg = palette["light-blue"]
# Color of the scrollbar in completion view
c.colors.completion.scrollbar.bg = palette["medium-gray"]
# Color of the scrollbar handle in completion view.
c.colors.completion.scrollbar.fg = palette["light-gray"]
# completion padding
# c.completion.padding = {'top': 2, 'bottom': 2, 'left': 4, 'right': 4}
c.completion.height = "50%"

# Downloads
# Background color for the download bar.
c.colors.downloads.bar.bg = palette["dark-gray"]
# Background color for downloads with errors.
c.colors.downloads.error.bg = palette["red"]
# Foreground color for downloads with errors.
c.colors.downloads.error.fg = palette["pure-white"]
# Color gradient start for download grays.
c.colors.downloads.start.bg = palette["blue"]
# Color gradient stop for download grays.
c.colors.downloads.stop.bg = palette["dark-green"]
# Color gradient start for download foregrounds.
c.colors.downloads.start.fg = palette["pure-white"]
# Color gradient stop for download foregrounds.
c.colors.downloads.stop.fg = palette["pure-white"]
# Color gradient interpolation system for download backgrounds.
# Valid values:
#   - rgb: Interpolate in the RGB color system.
#   - hsv: Interpolate in the HSV color system.
#   - hsl: Interpolate in the HSL color system.
#   - none: Don't show a gradient.
c.colors.downloads.system.bg = "rgb"
# Color gradient interpolation system for download foregrounds.
c.colors.downloads.system.fg = "rgb"
# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.

# Hints
c.colors.hints.bg = palette["yellow"]
# Font color for hints.
c.colors.hints.fg = palette["gray"]
c.hints.border = "1px solid " + palette["dark-gray"]
# Font color for the matched part of hints.
c.colors.hints.match.fg = palette["dark-green"]

# Keyhint
# Background color of the keyhint widget.
c.colors.keyhint.bg = palette["dark-gray"]
# Text color for the keyhint widget.
c.colors.keyhint.fg = palette["blue"]
# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = palette["green"]

# Messages
# Background color of an error message.
c.colors.messages.error.bg = palette["dark-gray"]
# Border color of an error message.
c.colors.messages.error.border = palette["light-gray"]
# Foreground color of an error message.
c.colors.messages.error.fg = palette["red"]
# Background color of an info message.
c.colors.messages.info.bg = palette["background"]
# Border color of an info message.
c.colors.messages.info.border = palette["light-gray"]
# Foreground color an info message.
c.colors.messages.info.fg = palette["foreground"]
# Background color of a warning message.
c.colors.messages.warning.bg = palette["background"]
# Border color of a warning message.
c.colors.messages.warning.border = palette["light-gray"]
# Foreground color a warning message.
c.colors.messages.warning.fg = palette["red"]
# Background color for prompts.

# Prompts
c.colors.prompts.bg = palette["background"]
# Border used around UI elements in prompts.
c.colors.prompts.border = "1px solid " + palette["light-gray"]
# Foreground color for prompts.
c.colors.prompts.fg = palette["foreground"]
# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = palette["light-gray"]

# Statusbar
# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = palette["dark-purple"]
# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = palette["foreground"]
# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = palette["dark-pink"]
# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = palette["foreground"]
# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = palette["background"]
# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = palette["foreground"]
# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = palette["background"]
# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = palette["foreground"]
# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = palette["dark-blue"]
# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = palette["foreground"]
# Background color of the statusbar.
c.colors.statusbar.normal.bg = palette["background"]
# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = palette["foreground"]
# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = palette["darker-purple"]
# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = palette["foreground"]
# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = palette["light-gray"]
# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = palette["foreground"]
# Background color of the progress bar.
c.colors.statusbar.progress.bg = palette["background"]
# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = palette["red"]
# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = palette["foreground"]
# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = palette["cyan"]
# Foreground color of the URL in the statusbar on successful load
c.colors.statusbar.url.success.http.fg = palette["green"]
c.colors.statusbar.url.success.https.fg = palette["green"]
# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = palette["yellow"]
# Status bar padding
c.statusbar.padding = {"top": 3, "bottom": 3, "left": 5, "right": 5}

# Tabs
# Background color of the tab bar.
c.colors.tabs.bar.bg = palette["light-gray"]
# Background color of unselected even tabs.
c.colors.tabs.even.bg = palette["pale-gray"]
# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = palette["bright-white"]
# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = palette["red"]
# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = palette["blue"]
# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = palette["green"]
# Color gradient interpolation system for the tab indicator.
# Valid values:
#   - rgb: Interpolate in the RGB color system.
#   - hsv: Interpolate in the HSV color system.
#   - hsl: Interpolate in the HSL color system.
#   - none: Don't show a gradient.
c.colors.tabs.indicator.system = "rgb"
# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = palette["lighter-gray"]
# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = palette["bright-white"]
# Background color of pinned unselected even tabs.
c.colors.tabs.pinned.even.bg = palette["pale-gray"]
# Foreground color of pinned unselected even tabs.
c.colors.tabs.pinned.even.fg = palette["bright-white"]
# Background color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.bg = palette["lighter-gray"]
# Foreground color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.fg = palette["bright-white"]
# Background color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.bg = palette["background"]
# Foreground color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.fg = palette["bright-white"]
# Background color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.bg = palette["background"]
# Foreground color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.fg = palette["bright-white"]
# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = palette["background"]
# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = palette["bright-white"]
# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = palette["background"]
# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = palette["bright-white"]
# Tab padding
c.tabs.padding = {"top": 5, "bottom": 5, "left": 9, "right": 9}
c.tabs.indicator.width = 3
c.tabs.favicons.scale = 1.0
c.tabs.background = True

# c.url.start_pages  ""
# c.url.default_page= ""

c.tabs.title.format = "{audio}{index}:{current_title}"
c.tabs.position = "left"  # right
c.tabs.show = "multiple"
c.tabs.width = "13%"

c.fonts.web.size.default = 16

c.url.searchengines = {
    # note - if you se duckduckgo, you can make
    # use of its buit in bangs, of which there are many!
    # https://duckdukgo.com/bangs
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "dd": "https://duckduckgo.com/?q={}",
    "gg": "https://google.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "gho": "https://github.com/{}",
    "rd": "https://reddit.com/search/?q={}",
    # "so": "https://stackoverflow.com/search?q={}",
    "wk": "https://en.wikipedia.org/wiki/{}",
    "yt": "https://youtube.com/results?search_query={}",
    "ytm": "https://music.youtube.com/search?q={}",
}

c.completion.open_categories = [
    "searchengines",
    "quickmarks",
    "bookmarks",
    "history",
    "filesystem",
]

c.auto_save.session = True  # save tabs on quit/restart

# Aliases
c.aliases = {
    "o": "open",
    "q": "quit",
    "Q": "close",
    "w": "session-save",
    "x": "quit --save",
}
# Keybinding changes
config.bind("C", "set-cmd-text -s :set -t")
config.bind("e", "config-edit")
# config.bind("cs", "set-cmd-text -s :config-source")
config.bind("cs", "config-source")
config.bind("R", "restart")
config.bind("h", "history")
config.bind("H", "help")
config.bind("oo", "set-cmd-text -s :open")
config.bind("Ow", "set-cmd-text -s :open -w")
config.bind("to", "set-cmd-text -s :open -t")
config.bind("P", "set-cmd-text -s :open -p")
config.bind("W", "tab-clone -w")
config.bind("w", "tab-close")
config.bind("x", "quit --save")
config.bind("X", "window-only")
config.bind("pi", "tab-pin")
config.bind("tt", "set-cmd-text -s :tab-take")
config.bind("tg", "tab-give")
config.bind("r", "reload")  # F5
config.bind("yy", "yank url")  # yy
config.bind("yu", "hint url yank")  # ;y
config.bind("yi", "hint images yank")
config.bind("m", "bookmark-list")
config.bind("M", "bookmark-add")
config.bind("n", "tab-clone")
config.bind("N", "tab-clone -w")
config.bind("T", "hint links tab")
config.bind("i", "hint inputs")
config.bind("[", "set-cmd-text -s :tab-move")
config.bind("F", "hint links open")
config.bind("f", "hint links run :open {hint-url}")
# config.bind("f", "hint links run :open -p {hint-url}")
# config.bind("a", "mode-enter insert")
config.bind("1", "config-cycle tabs.show always switching")  # tH
config.bind("2", ":tab-next")  # J
config.bind("3", ":tab-prev")  # K
config.bind("8", "config-cycle tabs.position top left")  # tT
config.bind("0", "config-cycle statusbar.show always in-mode")  # sH
config.bind("pP", "open -- {primary}")
config.bind("~", "open -- {clipboard}")  # pp
config.bind("`", "open -t -- {clipboard}")  # pt
config.bind("qm", "micro-record")
config.bind("gJ", "tab-move +")
config.bind("gK", "tab-move -")
config.bind("gm", "tab-move")
config.bind("<Ctrl-+>", "zoom-in")  # zi
config.bind("<Ctrl-->", "zoom-out")  # zo
config.bind("<Ctrl-=>", "zoom")  # zz
config.bind("ym", "open -t https://music.youtube.com/")
config.bind("d", "devtools")
config.bind("D", "devtools-focus")
config.bind("S", "view-source --edit")
# config.bind("e", "edit-text")
# config.bind("E", "cmd-edit")
# config.bind("<ctrl-y>", "spawn --userscript ytdl.sh")
config.bind(
    ";I",
    "hint images spawn --output-message wget --content-disposition --no-clobber -P "
    + download_dir
    + "/images/ -c {hint-url}",
)
config.bind(
    ";i",
    "hint images spawn --output-message "
    + script_path
    + " {hint-url} "
    + download_dir,
)
# config.bind(
#     "cc", 'hint images spawn --userscript /bin/sh -c "echo -n {hint-url} | wl-copy"'
# )
# for i in range(1, 10):
#     config.bind(f"<Alt-{i}>", f"tab-focus {i}")

# Dark mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.preferred_color_scheme = "auto"
# config.set("colorswebpage.darkmode.enabled", False, "file://*")

# styles, cosmetics
c.content.user_stylesheets = [qt_path + "/styles/youtube-tweaks.css"]
c.tabs.indicator.width = 0  # no tab indicators
# c.window.transparent = True  # apparently not needed
c.tabs.width = "15%"

# fonts
c.fonts.default_family = []
c.fonts.default_size = "13pt"
c.fonts.web.family.fixed = "monospace"
c.fonts.web.family.sans_serif = "monospace"
c.fonts.web.family.serif = "monospace"
c.fonts.web.family.standard = "monospace"

# privacy
c.completion.cmd_history_max_items = 0
c.content.private_browsing = False
c.content.webgl = False
c.content.canvas_reading = False
c.content.geolocation = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.cookies.accept = "all"
c.content.cookies.store = True
c.content.javascript.enabled = False  # tsh keybind to toggle
config.set("content.javascript.enabled", True, "https://www.google.com/*")
config.set("content.javascript.enabled", True, "https://www.youtube.com/*")
config.set("content.javascript.enabled", True, "https://music.youtube.com/*")

# Content
c.content.pdfjs = True
c.content.autoplay = False

# Downloads
c.downloads.location.directory = download_dir
c.downloads.position = "bottom"

# File handling
c.fileselect.handler = "external"
c.fileselect.single_file.command = [
    term,
    "--class",
    "Qutebrowser_File_Picker",
    "-e",
    "yazi",
    "--choose-file",
    "{}",
]
c.fileselect.multiple_files.command = [
    term,
    "--class",
    "Qutebrowser_File_Picker",
    "-e",
    "yazi",
    "--choose-files",
    "{}",
]

# User agent
user_agent_string = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.3 Firefox/121"
config.set("content.headers.user_agent", user_agent_string, "<all>")

c.input.insert_mode.auto_load = True
# c.spellcheck.languages = ["en-US"]
c.confirm_quit = ["always"]

config.load_autoconfig()  # load settings done via the gui

c.content.blocking.enabled = True
c.content.blocking.method = "both"
# c.content.blockingmethod = 'adblock' # uncomment this if you install python-adblock
# c.content.blockingadblock.lists = [
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
#         "https://gthub.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"]
