#Linda Biasci

import pathlib
import subprocess

from ._version import __version__ as __base_version__

def _git_suffix() -> str:
    """Since we are in a git repository, let's add a suffix to the version string - 
    in order to keep the versioning information updated.
    This will return something like '+gf0f18e6.dirty'.
    """
    # Setting parameters so that git commands run in current working directory
    kwargs = dict(cwd=pathlib.Path(__file__).parent, stderr=subprocess.DEVNULL)
    try:
        # Retrieving the git's short secure hash algorithm to be appended to the base_version string
        args = ["git", "rev-parse", "--short", "HEAD"]
        sha = subprocess.check_output(args, **kwargs).decode().strip()
        suffix = f"+g{sha}"
        # If there are some uncommitted changes, append '.dirty' to the version suffix
        args = ["git", "diff", "--quiet"]
        if subprocess.call(args, stdout=subprocess.DEVNULL, **kwargs) != 0:
            suffix = f"{suffix}.dirty"
        return suffix
    except Exception:
        return ""

__version__ = f"{__base_version__}{_git_suffix()}"
