# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import importlib.metadata

from FirstAttemptRep import __version__, __name__ as __package_name__

_metadata = importlib.metadata.metadata(__package_name__)

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = __package_name__
copyright = '2025, Linda Biasci'
author = 'Linda Biasci'
version = __version__
release = version

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    # documentation is automatically generated from source code:
    "sphinx.ext.autodoc",
    # allow ..todo:: elements to be visualised:
    "sphinx.ext.todo",
    # include links to the source code in compiled documents:
    "sphinx.ext.viewcode",
]
autodoc_default_options = {
    "members": True,
    "member-order": "bysource",
    "undoc-members": True,
    "private-members": True
}

# show todo elements in compiled documentation:
todo_include_todos = True

pygments_style = "default"
pygments_dark_style = "default"

language = "en"

# Options for markup 
rst_prolog = f"""
.. |Python| replace:: 'Python <https://www.python.org/>'__
.. |Sphinx| replace:: 'Sphinx <https://www.sphinx-doc.org/en/master/>'__
.. |numpy| replace:: 'NumPy <https://numpy.org/>'__
.. |GitHub| replace:: 'GitHub <https://github.com/>'__
"""

# Options for templating
templates_path = ['_templates']

# Options for source files
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'alabaster'
html_theme_options = {
    "awesome_external_links": True,
}
html_logo = "_static/logo_small.png"
html_favicon = "_static/favicon.ico"
html_permalinks_icon = "<span>#</span>"
html_static_path = ["_static"]
