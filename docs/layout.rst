.. _layout:

Repository layout
=================

The fundamental parts of FirstAttemptRep's structure are the following:

.. code-block:: text

   FirstAttemptRep/
   ├── .github/
   │  └── workflows/
   │     ├── ci.yml
   |     └── docs.yml
   ├── docs/
   │  └── conf.py
   │  └── index.rst
   ├── src/
   │  └── FirstAttemptRep/
   │     ├── __init__.py
   │     ├── _version.py
   │     └── exampleprogram.py
   └── tests/
      └── test_exampleprogram.py
   ├── LICENSE
   ├── README.md
   ├── noxfile.py
   └── pyproject.toml

Source code
-----------

The source code (i.e. the actual Python modules) is 
typically the most important part of a repository.
At the very minimum the source code includes:

* ``__init__.py``, a special Python file that is used to mark a directory as a Python package
  (in the simplest case the the file can be empty, though this is not the case).
  For more information:
  `here <https://docs.python.org/3/tutorial/modules.html#packages>`__
* all the Python modules that the package needs
  (in this case, it's just a very simple file).
  For more information take a look at :ref:`source.exampleprogram`
* ``_version.py``, needed for the versioning implementation

For more information:
`here <https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/>`__

Documentation
-------------

Everything that is needed for the documentation of a Python package is in the ``docs`` folder.
For more information take a look at :ref:`documentation`

Unit tests
----------

The ``tests`` folder contains all the unit tests.
Typically, each |Python| module in a package has its test.
For more information take a look at :ref:`linting&testing`

Everything else
-----------

Other files to be found in the repository:

* ``pyproject.toml``: this fundamental file allows a package to be installed
* ``noxfile.py``: this file is used for automating recurrent development tasks while
  operating on a working copy of the repository
* ``README.md``: this file is what appears in the default landing page on github,
  it's basically the first thing that is seen
* ``LICENSE``: this file contains all the information about the package's license
* ``.github/workflows``: a folder that contains the GitHub Actions workflows for
  automating tasks (for instance, testing)
