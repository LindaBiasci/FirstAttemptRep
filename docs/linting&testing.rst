.. _linting&testing:

Static code analysis
====================

Since |Python| is an interpreted coding language, linting (i.e. static code analysis) and
testing are useful tools to catch issues and bugs in a |Python| program before running it.

In particular, the `static code analysis` is the process of examining source code without 
executing it to find potential errors, bugs, or simple possible improvements. It's 
referred to as `static` because the analysis is done on the code at rest, not at runtime.
Static code analysis basically allows to:
+ enforcing |Python|'s coding conventions and type correctness
+ catching logical problems and improving the overall code quality 

Some applications that might be used (they need to be installid via ``pip``):

* Pylint: launch it with 
.. code-block:: shell

  pylint exampleprogram.py

The default behaviour of Pylint can be partially modified adding a configuration 
section in the ``pyproject.toml`` file. For more information:
`here <https://pylint.readthedocs.io/en/latest/?badge=latest>`_

* Ruff: launch it with 
.. code-block:: shell

  ruff check

The default behaviour of Ruff can be customised adding a configuration section in the
``pyproject.toml`` file. For more information: 
`here <https://docs.astral.sh/ruff/configuration/>`__

Unit testing
============

Unit testing can be implemented via ``pytest`` (it needs to be installed via ``pip``).
Launch it with
.. code-block:: shell

  pytest

Typically, each module in the ``src`` folder has its corresponding Python file in the
``tests`` folder that implements all the unit tests (basically, a bunch of functions
of the ``test_something`` kind).

All unit tests should start running whenever the code is changed in any way.
Therefore, it's useful to make this procedure automatic: this is possible with 
``continuous integration``.
