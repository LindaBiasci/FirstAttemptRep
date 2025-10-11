.. _documentation:

Documentation
=============

The |Sphinx| package was used to generate the documentation.

Important parts of documenting a software project are:

* some descriptive text explaining the purpose and usage of the project (in this case,
  take a look at :ref:`source: exampleprogram` and :ref:`assignments`)
* technical documentation (sometimes referred to as Advanced Programming Interfaces,
  or APIs), describing for instance the inner workings of the classes and functions 
  that the package makes available

Sphinx handles both these aspects: the first is expressed in the form of
some ``.rst`` markup files, while the second is extracted from the docstrings
in the Python code. 
In order to implement all these things, a Python configuration file is required:

.. literalinclude:: conf.py
   :language: python

Moreover, a master markup file ``index.rst`` should be generated:

.. literalinclude:: index.rst

For further information, look for the specific .rst file inside the docs folder.