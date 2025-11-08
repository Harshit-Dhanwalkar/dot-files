# Qutebrowser Custom Session Management & Theming

This repository contains a customized Qutebrowser setup focused on efficient **session management** and **thematic consistency** using shell scripts (Bash), Rofi/dmenu, and a Python configuration architecture.

---

## Setup and Installation

### Dependencies

This setup requires the following tools for full functionality:

- **Qutebrowser**
- **Rofi** or **dmenu** (for the session menu)
- **dunst** or **notify-send** compatible notification system

### Installation (Debian/Ubuntu/Pop!\_OS)

```bash
sudo apt install qutebrowser rofi dunst
```

Give executable permission to scripts:

```bash
chmod +x ~/.config/qutebrowser/userscripts/*.sh
```

## Script Overview (Userscripts)

| File Name                | Explanation                                                                                                                                                                                                                                           |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `session.sh`             | Main Launcher and Menu. Uses Rofi/dmenu (with dark theme support) handles Launching an existing session, Creating a new session, and Deleting an old session with confirmation and desktop notifications.                                             |
| `qutebrowser-wrapper.sh` | Core Session Isolator. This script wraps the Qutebrowser executable. It uses the session name passed via `-r/--restore` to create completely isolated directories for cookies, history, and cache, making each session truly separate and persistent. |
| `img_dl.sh`              | Image Downloader Userscript. A utility to download images using `wget` and save them with a timestamped filename into a designated directory.                                                                                                         |
| `print_url.sh`           | Basic Utility Userscript. Opens a simple terminal window to display the URL of the current tab for quick viewing or copying.                                                                                                                          |

## Configuration Overview

| File Name                     | Explanation                                                                                                                                                             |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `config.py`                   | All core Qutebrowser configuration options, including custom editor/file manager paths and userscript bindings. It initializes the color theme.                         |
| `color_palette.py`            | Defines multiple theme dictionaries containing a comprehensive set of color names used for theming.                                                                     |
| `color_settings.py`           | Contains a function (`apply_color_from_palette`) that maps the defined colors from a palette to dozens of specific Qutebrowser settings for consistent theming.         |
| `qutebrowser-session.desktop` | A standard `.desktop` file that allows the `session.sh` menu script to be launched via an application launcher, making it easily accessible outside of a terminal bind. |
