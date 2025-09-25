#Linda Biasci
"""Unit test for exampleprogram.py"""

import numpy as np
import pytest

from FirstAttemptRep.exampleprogram import conversion

def test_numbers():
    """Testing the conversion function with numbers -
    regardless of them being integers or float.
    Anyway, the output is always a float.
    """
    assert conversion(10e-11) == 10.
    assert conversion(1.*10e-11) == 10.
    assert conversion(10e-12) == 0.
    assert conversion(1.*10e-12) == 0.

def test_array():
    """Testing the conversion function with arrays - 
    quite similar to the previous test.
    """
    assert np.allclose(conversion(np.full(20, 10e-11)), np.full(20, 10.))
    assert np.allclose(conversion(np.full(90, 1.*10e-12)), np.full(90, 0.))

def test_string():
    """Testing the conversion function with strings:
    using a string as an input should result in an error.
    """
    with pytest.raises(TypeError) as exception:
        conversion('something')
    print(f'Caught exception {exception}')
