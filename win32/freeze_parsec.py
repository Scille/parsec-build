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

    # Bootstrap parsec-cloud git repo
    if not PARSEC_REPO_DIR.is_dir():
        print("Clone Parsec repo")
        run(f"git clone {PARSEC_REPO_URL} --branch {parsec_tag} {PARSEC_REPO_DIR}")

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

    # Bootstrap virtualenv
    if not VENV_DIR.is_dir():
        run(f'python -m venv {VENV_DIR}')

    run(f"{VENV_DIR / 'Scripts/pip' } install cx-Freeze==6.0")
    run(f"{VENV_DIR / 'Scripts/pip' } install {PARSEC_REPO_DIR}[core]")

    # Run cxfreeze
    run(f"{VENV_DIR / 'Scripts/python'} setup.py build_exe")

    # Rename output directory
    to_move_target, = BUILD_DIR.glob('exe.win32-*')
    target_final = BUILD_DIR / f'parsec-{parsec_verbose_version}-{get_archslug()}'
    to_move_target.rename(target_final)

    # Add version file for NSIS installer
    (target_final / 'VERSION').write_text(f"{parsec_verbose_version}\n")


if __name__ == "__main__":
    main()
