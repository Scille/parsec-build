import sys
import re
import platform
import subprocess
from pathlib import Path


BUILD_DIR = Path("build").resolve()

VENV_DIR = BUILD_DIR / "venv"

PARSEC_REPO_URL = "https://github.com/Scille/parsec-cloud.git"
PARSEC_REPO_DIR = BUILD_DIR / "parsec-cloud"


def get_archslug():
    bits, _ = platform.architecture()
    return 'win32' if bits == '32bit' else 'win64'


def run(cmd, **kwargs):
    print(f">>> {cmd}")
    ret = subprocess.run(cmd, shell=True, **kwargs)
    assert ret.returncode == 0, ret.returncode
    return ret


def main():
    if len(sys.argv) != 2:
        raise SystemExit(f'usage: {sys.argv[0]} <parsec_tag>')
    parsec_tag = sys.argv[1]

    BUILD_DIR.mkdir(parents=True, exist_ok=True)

    # # Bootstrap parsec-cloud git repo
    # if not PARSEC_REPO_DIR.is_dir():
    #     print("Clone Parsec repo")
    #     run(f"git clone {PARSEC_REPO_URL} --branch {parsec_tag} {PARSEC_REPO_DIR}")

    # Patch parsec.__version__ according to git commit
    ret = run(f"git -C {PARSEC_REPO_DIR} describe --tag", stdout=subprocess.PIPE)
    assert ret.returncode == 0
    parsec_verbose_version = ret.stdout.decode().strip()
    print(f'Git tag/commit {parsec_tag} corresponds to Parsec version {parsec_verbose_version}')
    parsec_version_file = PARSEC_REPO_DIR / 'parsec/_version.py'
    parsec_version_file.write_text(
        re.sub(
            r'^__version__ = .*',
            f'__version__ = "{parsec_verbose_version}"',
            parsec_version_file.read_text(),
            flags=re.MULTILINE
        )
    )

    # # Bootstrap virtualenv
    # if not VENV_DIR.is_dir():
    #     run(f'python -m venv {VENV_DIR}')

    # run(f"{VENV_DIR / 'Scripts/pip' } install cx-Freeze==6.0")
    # run(f"{VENV_DIR / 'Scripts/pip' } install {PARSEC_REPO_DIR}[core]")

    # # Run cxfreeze
    # run(f"{VENV_DIR / 'Scripts/python'} setup.py build_exe")

    # # Rename output directory
    # to_move_target, = BUILD_DIR.glob('exe.win32-*')
    target_final = BUILD_DIR / f'parsec-{parsec_verbose_version}-{get_archslug()}'
    # to_move_target.rename(target_final)

    # Include LICENSE file
    (target_final / 'LICENSE.txt').write_text((PARSEC_REPO_DIR / 'LICENSE').read_text())

    # Create build info file for NSIS installer
    (BUILD_DIR / 'BUILD.tmp').write_text(
        f'target = "{target_final}"\n'
        f'parsec_version = "{parsec_verbose_version}"\n'
        f'python_version = "{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"\n'
        f'platform = "{get_archslug()}"\n'
    )

    # Create the install and uninstall file list for NSIS installer
    # target_files = []
    # target_folders = []
    # def _recursive_collect_target_files(curr_dir):
    #     for entry in curr_dir.iterdir():
    #         if entry.is_dir():
    #             target_folders.append(entry.relative_to(target_final))
    #             _recursive_collect_target_files(entry)
    #         else:
    #             target_files.append(entry.relative_to(target_final))
    # _recursive_collect_target_files(target_final)


    # target_files = []
    # def _recursive_collect_target_files(curr_dir):
    #     subdirs = []
    #     for entry in curr_dir.iterdir():
    #         if entry.is_dir():
    #             subdirs.append(entry)
    #         else:
    #             target_files.append(entry.relative_to(target_final))
    #     for subdir in subdirs:
    #         _recursive_collect_target_files(subdir)
    # _recursive_collect_target_files(target_final)

    target_files = []
    def _recursive_collect_target_files(curr_dir):
        subdirs = []
        for entry in curr_dir.iterdir():
            if entry.is_dir():
                subdirs.append(entry)
            else:
                target_files.append((False, entry.relative_to(target_final)))
        for subdir in subdirs:
            target_files.append((True, subdir.relative_to(target_final)))
            _recursive_collect_target_files(subdir)
    _recursive_collect_target_files(target_final)

    install_files_lines = ["; Files to install", 'SetOutPath "$INSTDIR\\"']
    curr_dir = Path(".")
    for target_is_dir, target_file in target_files:
        if target_is_dir:
            install_files_lines.append(f'SetOutPath "$INSTDIR\\{target_file}"')
            curr_dir = target_file
        else:
            if curr_dir != target_file.parent:
                import pdb; pdb.set_trace()
            assert curr_dir == target_file.parent
            install_files_lines.append(f'File "${{PARSEC_FREEZE_BUILD_DIR}}\\{target_file}"')
    (BUILD_DIR / 'install_files.nsh').write_text('\n'.join(install_files_lines))

    uninstall_files_lines = ["; Files to uninstall"]
    for target_is_dir, target_file in reversed(target_files):
        if target_is_dir:
            uninstall_files_lines.append(f'RMDir "$INSTDIR\\{target_file}"')
        else:
            uninstall_files_lines.append(f'Delete "$INSTDIR\\{target_file}"')
    (BUILD_DIR / 'uninstall_files.nsh').write_text('\n'.join(uninstall_files_lines))


if __name__ == "__main__":
    main()
