import configparser
import os
import platform
import subprocess
import sys

import pyupdater_utils


def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)


if __name__ == "__main__":
    pyupdater_utils.switch_to_safe_dir()
    pyupdater_utils.get_update("0.0.2")

    config = configparser.ConfigParser()
    config.read(resource_path("parsec.cfg"))

    linux_script = """
        export SENTRY_URL={sentry_url}
        mkdir -p ~/.config/parsec
        LOG_FILE=~/.config/parsec/parsec-core.log
        echo Starting parsec core >> $LOG_FILE
        {parsec_cloud} core --log-level=DEBUG --log-file $LOG_FILE --I-am-John -A {backend_url} &
        sleep 1
        core_pid=$!
        {parsec_gui}
        kill $core_pid
    """.format(
        parsec_cloud=resource_path("parsec-cloud/parsec"),
        parsec_gui=resource_path("parsec-gui/parsec-gui"),
        **config["DEFAULT"]
    )

    windows_script = """
        set SENTRY_URL={sentry_url}
        set FUSE_LIBRARY_PATH={fuse_library_path}
        set LOG_FILE=%APPDATA%\\parsec\\parsec-core.log
        msiexec /i {winfsp_msi} /q
        mkdir %APPDATA%\\parsec 2> nul
        echo Starting parsec core >> %LOG_FILE%
        start powershell -Command "Get-Content %LOG_FILE% -Wait"
        start /b {parsec_cloud} core --log-level=DEBUG --log-file %LOG_FILE% --I-am-John -A {backend_url}
        timeout 1
        {parsec_gui}
        taskkill /im parsec.exe /f
    """.format(
        parsec_cloud=resource_path("parsec-cloud\\parsec.exe"),
        parsec_gui=resource_path("parsec-gui\\parsec-gui.exe"),
        winfsp_msi=resource_path("winfsp-1.3.18160.msi"),
        **config["DEFAULT"]
    )

    system = platform.system()
    if system == "Linux":
        subprocess.call(linux_script, shell=True)
    elif system == "Windows":
        windows_script = "&".join([i for i in windows_script.split("\n") if i.strip()])
        subprocess.call(windows_script, shell=True)
    else:
        sys.stderr.write("System not supported\n")
        sys.exit(1)
