import pyupdater_utils

if __name__ == "__main__":
    pyupdater_utils.switch_to_safe_dir()
    pyupdater_utils.get_update("0.0.1")
    pyupdater_utils.exit_not_installed()
