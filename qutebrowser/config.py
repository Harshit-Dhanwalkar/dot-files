# import subprocess

import os
import shutil

from theme.color_palette import palette02 as palette
from theme.color_settings import apply_color_from_palette

c = c
config = config

palette = palette
apply_color_from_palette(c, palette)

qt_path = os.path.expanduser("~/.config/qutebrowser")
script_path = os.path.expanduser("~/.config/qutebrowser/userscripts/")

download_dir = "~/Downloads/QuteBrowser-downloads"
download_dir = os.path.expanduser(download_dir)
if not os.path.exists(download_dir):
    os.makedirs(download_dir)

term = shutil.which("st")
if term is None:
    term = "/usr/local/bin/st"
editor = shutil.which("kitty")
if editor is None:
    editor = os.path.expanduser("~/.local/kitty.app/bin/kitty")
c.editor.command = [term, "-e", editor, "{}"]

# Hints
c.hints.radius = 0
c.hints.scatter = True
c.hints.uppercase = False

# Completion
# c.completion.padding = {'top': 2, 'bottom': 2, 'left': 4, 'right': 4}
c.completion.height = "50%"

# Tabs
c.tabs.padding = {"top": 5, "bottom": 5, "left": 9, "right": 9}
c.tabs.indicator.width = 3
c.tabs.favicons.scale = 1.2
c.tabs.background = True
# config.set("colors.tabs.favicon.default", "file:///<path/to/png>", "qute://*")

# c.url.start_pages = ["https://en.wikipedia.org/wiki/Main_Page"]
# c.url.default_page = "https://duckduckgo.com"

c.tabs.title.format = "{audio}{index}:{current_title}"
c.tabs.position = "left"  # right
c.tabs.show = "multiple"
c.tabs.width = "13%"

c.fonts.web.size.default = 16

# Intert Mode
c.input.forward_unbound_keys = "auto"  # all, none
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = True  # False

with config.pattern("*://www.reddit.com/*") as p:
    p.hints.selectors["all"].append("#reddit-search-input-id")

c.url.searchengines = {
    # note - if you see duckduckgo, you can make
    # use of its buitt in bangs, of which there are many!
    # https://duckdukgo.com/bangs
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "dd": "https://duckduckgo.com/?q={}",
    "ddb": "https://duckduckgo.com/bangs/?g={}",
    "gg": "https://google.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "gho": "https://github.com/{}",
    "rd": "https://reddit.com/search/?q={}",
    "wk": "https://en.wikipedia.org/wiki/{}",
    "yt": "https://youtube.com/results?search_query={}",
    "ytm": "https://music.youtube.com/search?q={}",
    # "so": "https://stackoverflow.com/search?q={}",
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
config.bind("r", "reload")  # F5
config.bind(",tt", ":open -t")  # t and ,tt
config.bind("t", ":open -t")  # t and ,tt
config.bind("o", "set-cmd-text -s :open")
config.bind("O", "set-cmd-text -s :open -t")  # o and ,ot
config.bind(",ot", "set-cmd-text -s :open -t")  # o and ,ot
config.bind(",ow", "set-cmd-text -s :open -w")
config.bind("n", "tab-clone")
config.bind("N", "tab-clone -w")
config.bind("P", "set-cmd-text -s :open -p")
config.bind("<Alt-h>", "back")
config.bind("<Alt-l>", "forward")
config.bind("W", "tab-clone -w")
config.bind("w", "tab-close")
config.bind("x", "quit --save")
config.bind("X", "window-only")
config.bind(",x", "window-only")
config.bind("pi", "tab-pin")
# config.bind("th", "set-cmd-text -s :tab-take")
# config.bind("tg", "tab-give")
config.bind("yy", "yank url")  # yy
config.bind("yu", "hint url yank")  # ;y
config.bind("yi", "hint images yank")
config.bind("m", "quickmark-save")  # m
config.bind("M", "open -t qute://bookmarks")
# config.bind("m", "bookmark-add")  # M
# config.bind("mm", "set-cmd-text :bookmark-add {url} ")
# config.bind("md", ":bookmark-del")
config.bind("[", "set-cmd-text -s :tab-move")
config.bind("i", "hint inputs")
config.bind("F", "hint links tab-bg")
config.bind("f", "hint all run :open {hint-url}")
config.bind("T", "hint links tab")
config.bind(",-", "set tabs.title.format '{audio}' ;; set tabs.width 2%")
config.bind(
    ",+", "set tabs.title.format '{audio}{index}:{current_title}' ;; set tabs.width 15%"
)
# config.bind("f", "hint links run :open -p {hint-url}")
# config.bind("a", "mode-enter insert")
config.bind("1", "config-cycle tabs.show always switching")  # tH
config.bind("2", ":tab-next")  # J
config.bind("3", ":tab-prev")  # K
config.bind("8", "config-cycle tabs.position top left")  # tT
config.bind("0", "config-cycle statusbar.show always in-mode")  # sH
config.bind("pP", "open -- {primary}")
config.bind("pp", "open -- {clipboard}")  # pp
config.bind("pt", "open -t -- {clipboard}")
config.bind("qm", "micro-record")
config.bind("gJ", "tab-move +")
config.bind("gK", "tab-move -")
config.bind("gm", "tab-move")
config.bind("<Ctrl-+>", "zoom-in")  # zi
config.bind("<Ctrl-->", "zoom-out")  # zo
config.bind("<Ctrl-=>", "zoom")  # zz
config.bind("d", "devtools")
config.bind("D", "devtools-focus")
config.bind("S", "view-source --edit")
# config.bind("e", "edit-text")
# config.bind("E", "cmd-edit")
# config.bind("<ctrl-y>", "spawn --userscript ytdl.sh")
config.bind(";w", "hint link spawn --detach mpv --force-window yes {hint-url}")
config.bind(";W", "spawn --detach mpv --force-window yes {url}")
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
    + "img_dl.sh"
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
# config.set("colors.webpage.darkmode.enabled", False, "file://*")

# styles, cosmetics
c.content.user_stylesheets = [qt_path + "/styles/youtube-tweaks.css"]
c.tabs.indicator.width = 0  # no tab indicators
c.window.transparent = True  # apparently not needed
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
c.content.canvas_reading = True
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
# c.qt.args += ["--pdfjs-args=disableFontSubpixelAA: true"]
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
