#Linda Biasci

import pathlib
import shutil

import nox

from FirstAttemptRep import __name__ as __package_name__

# Basic environment
_ROOT_DIR = pathlib.Path(__file__).parent
_DOCS_DIR = _ROOT_DIR / "docs"
_SRC_DIR = _ROOT_DIR / "src" / __package_name__
_TESTS_DIR = _ROOT_DIR / "tests"

# Folders containing source code that potentially needs linting
_LINT_DIRS = ("src", "tests", "Assignments")

# Reuse existing virtualenvs by default
nox.options.reuse_existing_virtualenvs = True

@nox.session(venv_backend="none")
def cleanup(session: nox.Session) -> None:
    """Cleanup temporary files:
    Remove all the __pycache__ folders, clean up the docs.
    """
    for folder_path in (_ROOT_DIR, _SRC_DIR, _TESTS_DIR):
        _path = folder_path / "__pycache__"
        if _path.exists():
            shutil.rmtree(_path)

    _path = _DOCS_DIR / "_build"
    if _path.exists():
            shutil.rmtree(_path)

@nox.session(venv_backend="none")
def docs(session: nox.Session) -> None:
    """Build the HTML documentation"""
    source_dir = _DOCS_DIR
    output_dir = _DOCS_DIR / "_build" / "html"
    session.run("sphinx-build", "-b", "html", source_dir, output_dir, *session.posargs)

@nox.session
def ruff(session: nox.Session) -> None:
    """Run ruff"""
    session.install("ruff")
    #session.install(".[dev]")
    session.run("ruff", "check", *session.posargs)

@nox.session
def pylint(session: nox.Session) -> None:
    """Run pylint"""
    session.install("pylint")
    #session.install(".[dev]")
    session.run("pylint", *_LINT_DIRS, *session.posargs)

@nox.session
def test(session: nox.Session) -> None:
    """Run the unit tests"""
    session.install("pytest")
    #session.install(".[dev]")
    session.run("pytest", *session.posargs)
