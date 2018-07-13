import os
import platform
import sys

from pyupdater.client import Client, AppUpdate

try:
    from client_config import ClientConfig  # pylint: disable=import-error
except ImportError:
    sys.stderr.write(
        "client_config.py is missing.\n"
        "You need to run: pyupdater init\n"
        "See: http://www.pyupdater.org/usage-cli/\n"
    )
    sys.exit(1)


def print_status_info(info):
    total = info.get(u"total")
    downloaded = info.get(u"downloaded")
    status = info.get(u"status")
    print(str(downloaded) + "/" + str(total), status)


def get_update(current_version):
    print("Current version is", current_version)
    client = Client(ClientConfig(), refresh=True, progress_hooks=[print_status_info])
    app_update = client.update_check(ClientConfig.APP_NAME, current_version, channel="stable")
    if app_update:
        print("There is a new update. Upgrading to version", app_update.latest, "...")
        print("Downloading...")
        if app_update.download():
            print("Extracting...")
            if isinstance(app_update, AppUpdate):
                app_update.extract_restart()
            else:
                app_update.extract()


def exit_not_installed():
    sys.stderr.write(
        ClientConfig.APP_NAME.capitalize() + " not installed\n"
        "Please download the full version instead of using the minimal installer\n"
    )
    sys.exit(1)


def switch_to_safe_dir():
    system = platform.system()
    # Fix bug at update restart
    if system == "Windows":
        cwd = os.path.dirname(os.path.abspath(sys.argv[0]))
    elif system == "Linux":
        cwd = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))
    else:
        sys.stderr.write("System not supported\n")
        sys.exit(1)
    os.chdir(cwd)
