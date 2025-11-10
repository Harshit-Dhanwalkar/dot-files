#!/bin/sh

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

: <<'END_COMMENT'
This script basically utilies (Socat(SOcket CAT))[https://www.kali.org/tools/socat/].
When opening a URL in an existing instance, the normal qutebrowser Python script is started and a few `PyQt` libraries need to be loaded until it is detected that there is an instance running to which the URL is then passed. This takes some time.
Instead, the script uses a lightweight utility (socat) to directly pass `url` to the unix socket that the running qutebrowser instance is constantly listening to, which is much faster and starts a new qutebrowser if it is not running already.


NOTE: I have hardcored this script in `qutebrowser-wrapper.sh` script. so this script is not in use anywhere. Evrything is taking care by the that alone script.
END_COMMENT

# initial idea: Florian Bruhin (The-Compiler)
# author: Thore Bödecker (foxxx0)
# https://github.com/qutebrowser/qutebrowser/blob/main/scripts/open_url_in_instance.sh

_url="$1"
_qb_version='1.0.4'
_proto_version=1
_ipc_socket="${XDG_RUNTIME_DIR}/qutebrowser/ipc-$(printf '%s' "$USER" | md5sum | cut -d' ' -f1)" # Identify the Communication Channel
_qute_bin="/usr/bin/qutebrowser"

printf '{"args": ["%s"], "target_arg": null, "version": "%s", "protocol_version": %d, "cwd": "%s"}\n' \
    "${_url}" \
    "${_qb_version}" \
    "${_proto_version}" \
    "${PWD}" | socat -lf /dev/null - UNIX-CONNECT:"${_ipc_socket}" ||
    "$_qute_bin" "$@" &

: <<'END_COMMENT'
1. Identify the Communication Channel -> `_ipc_socket="${XDG_RUNTIME_DIR}/qutebrowser/ipc-$(printf '%s' "$USER" | md5sum | cut -d' ' -f1)"` :
   - The Socket: The `_ipc_socket` variable defines the exact path to a UNIX socket file
   - When a qutebrowser instance starts, it creates this file and listens for commands. When the script runs, it calculates the exact same path using username `"$USER"`, ensuring it hits the correct channel for running browser.
2. The PayLoad:  `printf '{"args": ["%s"], "target_arg": null, "version": "%s", "protocol_version": %d, "cwd": "%s"}\n'`  -> converts the command-line arguments ($@) into a structured JSON object.
3. Send the Command Instantly -> `"${PWD}" | socat -lf /dev/null - UNIX-CONNECT:"${_ipc_socket}" || "$_qute_bin" "$@" &
4. `${PWD}" | socat -lf /dev/null - UNIX-CONNECT:"${_ipc_socket}"` The socat utility receives the JSON payload, opens the socket file, shoves the data into it, and immediately closes the connection.
5. The Fallback Logic -> ` ... || "$_qute_bin" "$@" &`
`

Why it's Fast?
-> Opening a UNIX socket is essentially reading and writing to a file on the local machine. It requires almost no system overhead compared to starting the Python interpreter, loading the Qt libraries, initializing the WebEngine backend, and finally having the new instance realize an old one is running. This socket transfer is virtually instantaneous.
END_COMMENT
