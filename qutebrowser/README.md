# My `qutebrowser` configuration

- Author  : Harshit Prashant Dhanwalkar
- Github  : @Harshit-Dhanwalkar

<img src="../assets/QtBrowser.jpg" alt="Qutebrowser" width="450">

---

A customized Qutebrowser setup focused on efficient **session management**, **fast launching** and **thematic consistency** using shell scripts (Bash), Rofi/dmenu, and a Python configuration architecture.

---

## Setup and Installation

### Dependencies

This setup requires the following tools for full functionality:

- **Qutebrowser**
- **Rofi** or **dmenu**
- **Dunst** or **notify-send** compatible notification system
- **SoCat**

### Installation (Debian/Ubuntu/Pop!\_OS)

```bash
sudo apt install qutebrowser rofi dunst socat
```

Give executable permission to scripts:

```bash
chmod +x ~/.config/qutebrowser/userscripts/*.sh
```

## Script Overview (Userscripts)

| File Name                                                        | Explanation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| :--------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`session.sh`](userscripts/session.sh)                           | Uses Rofi/dmenu (with `dark theme` support) to handle Launching an existing session, Creating a new session, and Deleting an old session with confirmation and desktop notifications.                                                                                                                                                                                                                                                                                                                                               |
| [`qutebrowser-wrapper.sh`](userscripts/qutebrowser-wrapper.sh)   | Core Session Isolator and Fast IPC Launcher.This script has two key functions: <ul><li>Speed Optimization: It first attempts to instantly pass commands (like URLs or session restores) to a running Qutebrowser instance via a UNIX socket (`socat`) for near-zero-latency opening.</li><li>Session Isolation: If no instance is running, it falls back to wrapping the Qutebrowser executable to create isolated and persistent directories for cookies, history, and cache based on the session name (`-r/--restore`).</li></ul> |
| [`open_url_in_instance.sh`](userscripts/open_url_in_instance.sh) | (LOGIC MERGED in [`qutebrowser-wrapper.sh`](userscripts/qutebrowser-wrapper.sh)) : The core logic of this script is to establish fast IPC launch via `socat` to ensure all launches, including session restoration, are instant when an instance is already running.                                                                                                                                                                                                                                                                |
| [`img_dl.sh`](userscripts/img_dl.sh)                             | Image Downloader Userscript. A utility to download images using `wget` and save them with a timestamped filename into a download directory.                                                                                                                                                                                                                                                                                                                                                                                         |
| [`print_url.sh`](userscripts/print_url.sh)                       | (TEST SCRIPT) Basic Utility Userscript. Opens a simple terminal window to display the URL of the current tab for quick viewing or copying.                                                                                                                                                                                                                                                                                                                                                                                          |

## Configuration Overview

| File Name                                                                 | Explanation                                                                                                                                                             |
| ------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`config.py`](config.py)                                                  | All core Qutebrowser configuration options, including custom editor/file manager paths and userscript bindings. It initializes the color theme.                         |
| [`color_palette.py`](themes/color_palette.py)                             | Defines multiple theme dictionaries containing a comprehensive set of color names used for theming.                                                                     |
| [`color_settings.py`](themes/color_settings.py)                           | Contains a function (`apply_color_from_palette`) that maps the defined colors from a palette to dozens of specific Qutebrowser settings for consistent theming.         |
| [`qutebrowser-session.desktop`](DesktopEntry/qutebrowser-session.desktop) | A standard `.desktop` file that allows the `session.sh` menu script to be launched via an application launcher, making it easily accessible outside of a terminal bind. |
