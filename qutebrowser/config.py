# import subprocess
# import setproctitle
# setproctitle.setproctitle("qutebrowser")

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

# term = shutil.which("st")
# term = f'"{term}"'
# file_manager = shutil.which("yazi")
# file_manager = f'"{file_manager}"'
# editor = shutil.which("nvim")
# editor = f'"{editor}"'

term = "/usr/local/bin/st"
# term = "/home/harshitpd/.local/kitty.app/bin/kitty"
editor = "/home/linuxbrew/.linuxbrew/bin/nvim"
file_manager = "/home/linuxbrew/.linuxbrew/bin/yazi"
# file_manager = "org.gnome.Nautilus.desktop"

c.auto_save.session = True  # save tabs on quit/restart

# Hints
c.hints.radius = 0
c.hints.scatter = True
c.hints.uppercase = False
# c.hints.chars = "asdfghjklie"

# Completion
# c.completion.padding = {'top': 2, 'bottom': 2, 'left': 4, 'right': 4}
c.completion.height = "50%"
# Move on to the next part when there's only one possible completion left.
c.completion.quick = True
# When to show the autocompletion window.
# Valid values:
#   - always: Whenever a completion is available.
#   - auto: Whenever a completion is requested.
#   - never: Never.
c.completion.show = "always"

# Tabs
c.tabs.padding = {"top": 6, "bottom": 6, "left": 9, "right": 9}
c.tabs.indicator.width = 0  # no tab indicators, 4
c.tabs.favicons.scale = 1.2
c.tabs.background = False
# config.set("colors.tabs.favicon.default", "file:///<path/to/png>", "qute://*")
c.tabs.last_close = "close"  # ignore, blank, startpage, default-page, close
c.tabs.select_on_remove = "prev"  # next, prev, last-used
c.tabs.title.format = "{audio}{index}:{current_title}"
c.tabs.position = "left"  # right
c.tabs.show = "multiple"
c.tabs.width = "20%"
c.tabs.padding = {
    "left": 2,
    "right": 4,
    "top": 4,
    "bottom": 4,
}

# c.url.start_pages = ["https://en.wikipedia.org/wiki/Main_Page"]
# c.url.default_page = "https://duckduckgo.com"  # "black"

# Intert/Input Mode
c.input.forward_unbound_keys = "auto"  # all, none
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = True  # False

# Scrollbar
c.scrolling.bar = "overlay"  # when-searching, searching, always, never, overlay
c.scrolling.smooth = False
#  Note smooth scrolling does not work with the `:scroll-px` command

with config.pattern("*://www.reddit.com/*") as p:
    p.hints.selectors["all"].append("#reddit-search-input-id")

c.url.searchengines = {
    # note - make use of its builtin in bangs
    # https://duckduckgo.com/bangs
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

# Aliases
c.aliases = {
    "o": "open",
    "q": "quit",
    "Q": "close",
    "w": "session-save",
    "wq": "quit --save",
}
c.aliases.update(
    {
        "recycle": "quit --save _recycle",
        "restart": "quit --save _restart",
        "shutdown": "quit --save _shutdown",
    }
)

# Keybinding changes
config.bind("C", "set-cmd-text -s :set -t")
config.bind("e", "config-edit")
# config.bind("cs", "set-cmd-text -s :config-source")
config.bind("cs", "config-source")
config.bind("R", "restart")
config.bind("h", "history")
config.bind("H", "help")
config.bind("r", "reload")  # F5
config.bind("t", ":open -t")  # t and ,tt
config.bind(",tt", ":open -t")  # t and ,tt
# config.bind('o', 'spawn --userscript dmenu-open')
# config.bind('O', 'spawn --userscript dmenu-open --tab')
config.bind("o", "set-cmd-text -s :open")
config.bind("O", "set-cmd-text -s :open -t")  # o and ,ot
config.bind(",ot", "set-cmd-text -s :open -t")  # o and ,ot
config.bind(",ow", "set-cmd-text -s :open -w")
config.bind("yy", "yank url")  # yy
config.bind("yu", "hint url yank")  # ;y
config.bind("yi", "hint images yank")
config.bind("m", "quickmark-save")  # m
config.bind("M", "open -t qute://bookmarks")
config.bind("n", "tab-clone")
config.bind("N", "tab-clone -w")
config.bind("P", "set-cmd-text -s :open -p")
config.bind("<Alt-h>", "back")
config.bind("<Alt-l>", "forward")
config.bind("W", "tab-clone -w")
config.bind("w", "tab-close")
config.bind("wq", "quit --save")
config.bind("X", "window-only")
config.bind(",x", "window-only")
config.bind("pi", "tab-pin")
# config.bind("th", "set-cmd-text -s :tab-take")
# config.bind("tg", "tab-give")
# config.bind("m", "bookmark-add")  # M
# config.bind("mm", "set-cmd-text :bookmark-add {url} ")
# config.bind("md", ":bookmark-del")
config.bind("[", "set-cmd-text -s :tab-move")
config.bind("i", "hint inputs")
config.bind("F", "hint links tab-bg")
config.bind("f", "hint all run :open {hint-url}")
config.bind("T", "hint links tab")
config.bind(",-", "set tabs.title.format '{audio}' ;; set tabs.width 30")
config.bind(
    ",=", "set tabs.title.format '{audio}{index}:{current_title}' ;; set tabs.width 280"
)
# config.bind("f", "hint links run :open -p {hint-url}")
# config.bind("a", "mode-enter insert")
config.bind("1", "config-cycle tabs.show always switching")  # tH
config.bind("2", ":tab-next")  # J
config.bind("3", ":tab-prev")  # K
config.bind(
    "8",
    "config-cycle statusbar.show always never;; config-cycle tabs.show always never",
)  # xx
config.bind("9", "config-cycle tabs.position top left")  # tT
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
config.bind("<f12>", "inspector")
# `mpv` installation required
# config.bind(";w", "hint link spawn --detach mpv --force-window yes {hint-url}")
# config.bind(";W", "spawn --detach mpv --force-window yes {url}")
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
# c.content.user_stylesheets = [qt_path + "/styles/youtube-tweaks.css"]

# Windows
c.window.transparent = True  # apparently not needed

# fonts
nerd_font = "12pt 'JetBrain Mono Nerd Font'"
c.fonts.default_size = "13pt"
c.fonts.default_family = [nerd_font, "monospace"]
c.fonts.web.size.default = 18
c.fonts.web.family.fixed = "monospace"
c.fonts.web.family.sans_serif = "monospace"
c.fonts.web.family.serif = "monospace"
c.fonts.web.family.standard = "monospace"
c.fonts.completion.category = f"bold {nerd_font}"
c.fonts.completion.entry = nerd_font
c.fonts.debug_console = nerd_font
c.fonts.downloads = nerd_font
c.fonts.keyhint = nerd_font
c.fonts.messages.error = nerd_font
c.fonts.messages.info = nerd_font
c.fonts.messages.warning = nerd_font
c.fonts.prompts = nerd_font
c.fonts.statusbar = nerd_font
c.fonts.hints = "bold 13px 'DejaVu Sans Mono'"
# c.fonts.tabs = nerd_font

# privacy
# c.completion.cmd_history_max_items = 0
# c.content.notifications = "block"
config.set("content.notifications.enabled", True)
config.set("content.notifications.enabled", True, "https://www.youtube.com")
c.content.private_browsing = False
c.content.webgl = False
c.content.canvas_reading = True
c.content.geolocation = False
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.cookies.accept = "all"
c.content.cookies.store = True
c.content.javascript.enabled = False  # tsh keybind to toggle
config.set("content.images", True, "chrome-devtools://*")
config.set("content.cookies.accept", "all", "devtools://*")
config.set("content.cookies.accept", "all", "chrome-devtools://*")
config.set("content.javascript.enabled", True, "chrome-devtools://*")
config.set("content.javascript.enabled", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome://*/*")
config.set("content.javascript.enabled", True, "qute://*/*")
config.set("content.javascript.enabled", True, "https://www.google.com/*")
config.set("content.javascript.enabled", True, "https://www.youtube.com/*")
config.set("content.javascript.enabled", True, "https://music.youtube.com/*")

# User agent
user_agent_string = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.3 Firefox/121"
config.set("content.headers.user_agent", user_agent_string, "<all>")
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}",
    "https://web.whatsapp.com/",
)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0",
    "https://accounts.google.com/*",
)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36",
    "https://*.slack.com/*",
)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0",
    "https://docs.google.com/*",
)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0",
    "https://drive.google.com/*",
)

# Content
c.content.pdfjs = True
c.content.autoplay = False

# Downloads
c.downloads.location.directory = download_dir
c.downloads.location.prompt = True
c.downloads.position = "bottom"
c.downloads.open_dispatcher = "simple"

# File handling
c.editor.command = [
    term,
    "-e",
    editor,
    "{}",
    "+call cursor({line}, {column0})",
]
c.fileselect.handler = "external"
c.fileselect.single_file.command = [
    term,
    "-c" "Qutebrowser_File_Picker",
    "-e",
    "/bin/sh",
    "-c",
    f'{file_manager} --choose-file "{os.path.abspath("{}")}"',
]
c.fileselect.multiple_files.command = [
    term,
    "-c",
    "Qutebrowser_File_Picker",
    "-e",
    "/bin/sh",
    "-c",
    f'{file_manager} --choose-file "{os.path.abspath("{}")}"',
]
# c.fileselect.single_file.cleanup = True
# c.fileselect.multiple_files.cleanup = True

# Rendering, scrolling, and especially video performance.
c.qt.args = [
    "ignore-gpu-blocklist",
    "enable-gpu-rasterization",
    "enable-zero-copy",
    "enable-accelerated-video-decode",
    "enable-native-gpu-memory-buffers",
    "enable-oop-rasterization",
]
c.qt.args += ["--pdfjs-args=disableFontSubpixelAA: true"]

# c.spellcheck.languages = ["en-US"]
c.confirm_quit = ["downloads"]  # all, never, downloads, multiple-tabs
c.content.headers.accept_language = "en-US,en;q=0.8,fi;q=0.6"
c.content.proxy = "none"  # system, none
# c.content.ssl_strict = True #  Validate SSL handshakes.: Ture/False/ask
# c.content.user_stylesheets = "styles/user.css"

config.load_autoconfig()  # load settings done via the gui

c.content.blocking.enabled = True
c.content.blocking.method = "both"
# c.content.blocking.method = 'adblock' # uncomment this if you install python-adblock
c.content.blocking.adblock.lists = [
    # uAssets
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2025.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt",
    # Core filters
    "https://easylist.to/easylist/easylist.txt",  # Main ad blocking
    "https://easylist.to/easylist/easylist-german.txt",
]
c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts",
    "https://raw.githubusercontent.com/chadmayfield/privacy-filter-hosts/master/hosts.txt",
]
# c.content.blocking.adblock.glob_file = None  # Use the internal cache system
# c.content.blocking.hosts.glob_file = None  # Use the internal cache system
